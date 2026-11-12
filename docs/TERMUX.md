# Ejecutar Etho Bot en Termux (Android)

Funciona con Termux instalado desde **F-Droid** (la versión de Play Store está desactualizada). Necesitas Node.js 22.13 o superior, que el script instala solo.

## Instalación

```bash
pkg install -y git
git clone https://github.com/EthoSof/EthoBot.git
cd EthoBot
bash scripts/termux-setup.sh
```

El script instala Node.js, git, ffmpeg y las dependencias, crea el `.env` con una clave de sesión y una contraseña de administrador aleatorias, y deja el panel solo en el teléfono (`HOST=127.0.0.1`).

## Uso diario

| Acción | Comando |
| --- | --- |
| Iniciar en segundo plano | `bash scripts/termux-start.sh` |
| Ver registros | `tail -f logs/etho.log` |
| Detener | `bash scripts/termux-stop.sh` |
| Iniciar viendo la consola | `bash scripts/termux-start.sh --foreground` |

El panel está en `http://localhost:3000`, desde el navegador del mismo teléfono.

## Vincular WhatsApp

No puedes escanear un QR que está en la misma pantalla del teléfono. Al crear el bot, elige **vincular con código** e ingresa el número (con código de país, sin `+`). El panel muestra un código de 8 dígitos: en WhatsApp ve a *Dispositivos vinculados → Vincular con el número de teléfono* e ingrésalo. También puedes abrir el panel desde otro dispositivo si defines `HOST=0.0.0.0` en `.env` (queda abierto a tu red local).

## Que Android no lo cierre

- Ajustes de Android → Aplicaciones → Termux → Batería → **Sin restricciones**.
- Instala **Termux:API** (F-Droid) y `pkg install termux-api`: `termux-start.sh` usa `termux-wake-lock` para mantener la CPU despierta con la pantalla apagada.
- Mantén una notificación de Termux activa (no la deslices fuera).

## Diferencias con un servidor normal

- **ffmpeg**: se usa el del sistema (`pkg install ffmpeg`), no `ffmpeg-static`. Puedes forzar otra ruta con `FFMPEG_PATH`.
- **Stickers**: `wa-sticker-formatter` necesita `sharp`, que no existe en Android. Se convierte con ffmpeg a WebP 512x512; el sticker sale **sin** nombre de paquete ni autor.
- **Descargas de video/audio** (`yt-dlp`): opcional, `pkg install yt-dlp`.
- **Memoria**: `npm run start:termux` limita Node a 512 MB. Con 4 GB de RAM o menos, deja `MAX_ONLINE_BOTS` en 2 o 3 en `.env`.
- **Pagos con Stripe**: el teléfono no recibe webhooks desde internet. Para cobrar usa un servidor público (ver `docs/DEPLOY.md`) o un túnel (`pkg install cloudflared`).

## Actualizar

```bash
bash scripts/termux-stop.sh
git pull
npm install --omit=dev --omit=optional --ignore-scripts
bash scripts/termux-start.sh
```

## Problemas frecuentes

- **`npm install` falla en libsignal o baileys**: falta git. Ejecuta `pkg install git` y repite.
- **`Se necesita Node.js 22.13`**: `pkg upgrade nodejs`.
- **`ENOENT ffmpeg`**: `pkg install ffmpeg`.
- **El bot se desconecta al apagar la pantalla**: revisa el apartado "Que Android no lo cierre".
