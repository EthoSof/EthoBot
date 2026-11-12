// Vinculación de WhatsApp desde la terminal: permite usar el bot solo con `npm start`,
// sin abrir el panel web (pensado para Termux en el celular, VPS y consolas sin navegador).
import readline from 'node:readline/promises';
import { config } from '../config.js';

const MAX_RETRIES = 10;
const cleanPhone = (s) => String(s || '').replace(/\D/g, '');

/** Elige el bot "de la terminal": bot_principal, o el único bot registrado. */
function pickTerminalBot(bots) {
  return bots.find((b) => b.id === 'bot_principal') || (bots.length === 1 ? bots[0] : null);
}

async function ask(rl, question) {
  try {
    return (await rl.question(question)).trim();
  } catch {
    return ''; // entrada cerrada (Ctrl+D)
  }
}

async function askLinkMethod(defaultPhone) {
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  try {
    console.log('\n======================================================');
    console.log(' 📱 VINCULAR WHATSAPP');
    console.log('======================================================');
    console.log(' Este bot todavía no está conectado a un número de WhatsApp.');
    console.log('  1) Código de 8 dígitos  (recomendado si usas el bot en el mismo celular)');
    console.log('  2) Código QR            (escanearlo desde otro teléfono)');
    const method = (await ask(rl, ' Elige 1 o 2 [1]: ')) || '1';
    if (method !== '1') return { method: 'qr' };

    let phone = '';
    while (phone.length < 8) {
      const hint = defaultPhone ? ` [${defaultPhone}]` : '';
      phone = cleanPhone((await ask(rl, ` Número de WhatsApp del bot con código de país, sin + ni espacios (ej. 573001234567)${hint}: `)) || defaultPhone);
      if (phone.length < 8) console.log(' ⚠️  Número no válido. Incluye el código de país, por ejemplo 57 (Colombia), 52 (México), 54 (Argentina).');
    }
    return { method: 'code', phone };
  } finally {
    rl.close();
  }
}

/**
 * Prepara la vinculación del bot principal antes de encender los bots.
 * - Ya vinculado → no hace nada.
 * - PAIRING_NUMBER definido → código de 8 dígitos sin preguntar.
 * - Terminal interactiva → pregunta código o QR.
 * - Sin terminal (Docker, PM2, segundo plano) → QR en los logs.
 * Si el código/QR expira antes de vincular, genera otro automáticamente.
 */
export async function setupTerminalLink(botManager) {
  const bot = pickTerminalBot(botManager.ensureDefaultBot());
  if (!bot || !bot.is_active || botManager.isLinked(bot.id)) return;
  if (bot.payment_status === 'suspended' || (bot.expires_at > 0 && Date.now() > bot.expires_at && bot.payment_status !== 'paid')) return;

  const interactive = Boolean(process.stdin.isTTY && process.stdout.isTTY) && process.env.TERMINAL_LINK !== 'false';
  let choice;
  if (config.pairingNumber) choice = { method: 'code', phone: config.pairingNumber };
  else if (interactive) choice = await askLinkMethod(cleanPhone(bot.phone));
  else {
    console.log('[Vinculación] Escanea el QR que aparecerá abajo, o define PAIRING_NUMBER=573001234567 para recibir un código de 8 dígitos.');
    choice = { method: 'qr' };
  }

  const link = () => (choice.method === 'code'
    ? botManager.requestPairingCodeDirectly(bot.id, choice.phone).then((r) => {
        if (!r.ok) console.log(`\n⚠️  ${r.error}`);
      })
    : botManager.startBot(bot.id, true));

  // Reintentos automáticos si el código/QR caduca o WhatsApp rechaza el intento.
  let retries = 0;
  let done = false;
  const onUpdate = ({ botId, status }) => {
    if (done || botId !== bot.id) return;
    if (status === 'online') {
      done = true;
      botManager.off('bot_update', onUpdate);
      console.log('\n======================================================');
      console.log(` 🎉 ¡LISTO! ${bot.name} está conectado y funcionando.`);
      console.log(`  • Pruébalo: escribe ${bot.prefix || config.prefix}menu en un chat con el bot (o en tu propio chat si vinculaste tu número).`);
      console.log('  • Deja esta terminal abierta: si la cierras, el bot se apaga.');
      console.log('  • La sesión queda guardada; la próxima vez basta con npm start.');
      console.log('======================================================\n');
      return;
    }
    if (status === 'stopped' || status === 'logged_out') {
      if (++retries > MAX_RETRIES) {
        done = true;
        botManager.off('bot_update', onUpdate);
        console.log('\n⚠️  No se completó la vinculación. Reinicia con npm start para intentarlo de nuevo.');
        return;
      }
      console.log(`\n⏳ El ${choice.method === 'code' ? 'código' : 'QR'} expiró o fue rechazado. Generando uno nuevo (${retries}/${MAX_RETRIES})...`);
      setTimeout(() => link().catch((e) => console.log(`⚠️  ${e.message}`)), 3000);
    }
  };
  botManager.on('bot_update', onUpdate);

  if (choice.method === 'code') console.log(`\n⏳ Pidiendo a WhatsApp un código de vinculación para +${choice.phone}...`);
  await link().catch((e) => console.log(`⚠️  ${e.message}`));
}
