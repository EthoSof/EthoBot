import axios from 'axios';
import { execFile } from 'child_process';
import { promisify } from 'util';
import fs from 'fs';
import os from 'os';
import path from 'path';
import crypto from 'crypto';
import { createRequire } from 'module';

const execFileP = promisify(execFile);
const require = createRequire(import.meta.url);

/** Entorno Termux/Android: sus binarios son de bionic, así que se usa el ffmpeg del sistema. */
export const isTermux = process.platform === 'android' || !!process.env.TERMUX_VERSION || /com\.termux/.test(process.env.PREFIX || '');

/**
 * Localiza ffmpeg: 1) FFMPEG_PATH, 2) en Termux el del sistema (pkg install ffmpeg),
 * 3) el binario de ffmpeg-static si existe, 4) 'ffmpeg' del PATH.
 */
function resolveFfmpeg() {
  if (process.env.FFMPEG_PATH) return process.env.FFMPEG_PATH;
  if (!isTermux) {
    try {
      const p = require('ffmpeg-static');
      if (p && fs.existsSync(p)) return p;
    } catch { /* ffmpeg-static es opcional */ }
  }
  return 'ffmpeg';
}
export const ffmpegPath = resolveFfmpeg();
/** Añade al PATH la carpeta del ffmpeg (solo si es una ruta absoluta). */
export function ensureFfmpegInPath() {
  if (path.isAbsolute(ffmpegPath)) process.env.PATH = `${path.dirname(ffmpegPath)}${path.delimiter}${process.env.PATH}`;
}
/** Carpeta temporal: la del sistema y, si no se puede escribir (Termux sin TMPDIR), data/tmp. */
function pickTmp() {
  const candidates = [path.join(os.tmpdir(), 'tanjiro-bot'), path.join(process.cwd(), 'data', 'tmp')];
  for (const dir of candidates) {
    try { fs.mkdirSync(dir, { recursive: true }); fs.accessSync(dir, fs.constants.W_OK); return dir; } catch { /* siguiente */ }
  }
  return candidates[0];
}
export const TMP = pickTmp();

export const jidNorm = (j = '') => j.replace(/:\d+@/, '@');
export const jidNum = (j = '') => j.split('@')[0].split(':')[0];
export const fmt = (n) => Number(n || 0).toLocaleString('es-ES');
export const rand = (a, b) => Math.floor(Math.random() * (b - a + 1)) + a;
export const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];
export const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
export const levelOf = (exp) => Math.floor(Math.sqrt(exp / 50)) + 1;
export const expForLevel = (lvl) => 50 * (lvl - 1) ** 2;
export const sha1 = (buf) => crypto.createHash('sha1').update(buf).digest('hex');
export const slug = () => crypto.randomBytes(3).toString('hex');

/** Milisegundos restantes de un cooldown (0 si ya pasó). */
export const cd = (last, ms) => Math.max(0, (last || 0) + ms - Date.now());

export function timeLeft(ms) {
  const s = Math.ceil(ms / 1000);
  const h = Math.floor(s / 3600), m = Math.floor((s % 3600) / 60), sec = s % 60;
  return [h && `${h}h`, m && `${m}m`, (sec || (!h && !m)) && `${sec}s`].filter(Boolean).join(' ');
}

export async function getBuffer(url) {
  const r = await axios.get(url, { responseType: 'arraybuffer', timeout: 30000 });
  return Buffer.from(r.data);
}

export async function gifToMp4(buf) {
  const id = crypto.randomUUID();
  const inp = path.join(TMP, `${id}.gif`), out = path.join(TMP, `${id}.mp4`);
  fs.writeFileSync(inp, buf);
  try {
    await execFileP(ffmpegPath, ['-y', '-i', inp, '-movflags', 'faststart', '-pix_fmt', 'yuv420p',
      '-vf', 'scale=trunc(iw/2)*2:trunc(ih/2)*2', out], { timeout: 60000 });
    return fs.readFileSync(out);
  } finally {
    fs.rmSync(inp, { force: true });
    fs.rmSync(out, { force: true });
  }
}

export async function webpToPng(buf) {
  const id = crypto.randomUUID();
  const inp = path.join(TMP, `${id}.webp`), out = path.join(TMP, `${id}.png`);
  fs.writeFileSync(inp, buf);
  try {
    await execFileP(ffmpegPath, ['-y', '-i', inp, out], { timeout: 30000 });
    return fs.readFileSync(out);
  } finally {
    fs.rmSync(inp, { force: true });
    fs.rmSync(out, { force: true });
  }
}

/** Descarga con yt-dlp (debe estar instalado en el sistema). Devuelve { buffer, name }. */
export async function ytdlp(url, { audio = false, maxMB = 80 } = {}) {
  const id = crypto.randomUUID();
  const args = ['--no-playlist', '--no-warnings', '--max-filesize', `${maxMB}M`,
    '--ffmpeg-location', ffmpegPath, '-o', path.join(TMP, `${id}.%(ext)s`)];
  if (audio) args.push('-x', '--audio-format', 'mp3');
  else args.push('-f', 'bv*[ext=mp4][height<=720]+ba[ext=m4a]/b[ext=mp4]/b', '--merge-output-format', 'mp4');
  args.push('--', url);
  await execFileP('yt-dlp', args, { timeout: 240000 });
  const name = fs.readdirSync(TMP).find((n) => n.startsWith(id));
  if (!name) throw new Error('No se pudo descargar el archivo (¿supera el límite de tamaño?)');
  const file = path.join(TMP, name);
  const buffer = fs.readFileSync(file);
  fs.rmSync(file, { force: true });
  return { buffer, name };
}

/** Sticker WebP 512x512 con ffmpeg (sin sharp). Sirve para imagen y video/gif cortos. */
export async function stickerWithFfmpeg(buf, { video = false } = {}) {
  const id = crypto.randomUUID();
  const inp = path.join(TMP, `${id}.in`), out = path.join(TMP, `${id}.webp`);
  fs.writeFileSync(inp, buf);
  const vf = 'scale=512:512:force_original_aspect_ratio=decrease,pad=512:512:-1:-1:color=0x00000000' + (video ? ',fps=15' : '');
  const args = ['-y', '-i', inp, ...(video ? ['-t', '8', '-loop', '0'] : []), '-vf', vf, '-vcodec', 'libwebp', '-lossless', '0', '-q:v', '60', '-an', out];
  try {
    await execFileP(ffmpegPath, args, { timeout: 60000 });
    return fs.readFileSync(out);
  } finally {
    fs.rmSync(inp, { force: true });
    fs.rmSync(out, { force: true });
  }
}

export async function triggerWebhook(webhookUrl, eventName, data) {
  if (!webhookUrl || !webhookUrl.startsWith('http')) return;
  try {
    const payload = {
      event: eventName,
      timestamp: new Date().toISOString(),
      data
    };
    await fetch(webhookUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'User-Agent': 'Etho-Bot-Webhook/2.0' },
      body: JSON.stringify(payload)
    }).catch(() => {});
  } catch (err) {
    console.warn(`[webhook] Error enviando a ${webhookUrl}:`, err.message);
  }
}
