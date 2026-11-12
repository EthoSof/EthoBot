#!/data/data/com.termux/files/usr/bin/env bash
# Instala todo lo necesario para ejecutar Etho Bot en Termux (Android).
# Uso (dentro de la carpeta del proyecto):  bash scripts/termux-setup.sh
set -e

cd "$(dirname "$0")/.."

echo "==> Actualizando paquetes de Termux"
pkg update -y && pkg upgrade -y

echo "==> Instalando Node.js, git, ffmpeg y utilidades"
# git hace falta porque Baileys descarga libsignal desde GitHub; ffmpeg convierte stickers y audios.
pkg install -y nodejs git ffmpeg python openssl-tool termux-api || pkg install -y nodejs git ffmpeg python

NODE_MAJOR=$(node -p "process.versions.node.split('.')[0]")
NODE_MINOR=$(node -p "process.versions.node.split('.')[1]")
if [ "$NODE_MAJOR" -lt 22 ] || { [ "$NODE_MAJOR" -eq 22 ] && [ "$NODE_MINOR" -lt 13 ]; }; then
  echo "ERROR: se necesita Node.js 22.13 o superior (tienes $(node -v)). Ejecuta: pkg upgrade nodejs"
  exit 1
fi
echo "Node $(node -v) listo."

echo "==> Instalando dependencias del proyecto (sin binarios nativos que no existen en Android)"
# --ignore-scripts evita descargar ffmpeg-static y compilar sharp; en Termux se usa el ffmpeg del sistema.
npm install --omit=dev --omit=optional --ignore-scripts --no-audit --no-fund

echo "==> Preparando configuración"
mkdir -p data
if [ ! -f .env ]; then
  cp .env.example .env
  SECRET=$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
  ADMIN_PASS=$(node -e "console.log(require('crypto').randomBytes(9).toString('base64url'))")
  sed -i "s|^AUTH_SECRET=.*|AUTH_SECRET=$SECRET|" .env
  sed -i "s|^ADMIN_PASSWORD=.*|ADMIN_PASSWORD=$ADMIN_PASS|" .env
  sed -i "s|^HOST=.*|HOST=127.0.0.1|" .env
  echo ""
  echo "Se creó .env. Usuario admin: admin   Contraseña: $ADMIN_PASS"
  echo "Guárdala y cámbiala desde el panel (Perfil > Cambiar contraseña)."
else
  echo ".env ya existe, no se modifica."
fi

echo ""
echo "Listo. Inicia el bot con:  bash scripts/termux-start.sh"
echo "Opcional para descargas de video/audio:  pkg install yt-dlp"
