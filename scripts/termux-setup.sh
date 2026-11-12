#!/data/data/com.termux/files/usr/bin/env bash
# ==============================================================
# Instalador automático de Tanjiro Bot para Termux (Android)
# Uso: bash scripts/termux-setup.sh
# ==============================================================
set -e

cd "$(dirname "$0")/.."
PROJECT_DIR="$(pwd)"

# 1. Comprobar que no se ejecute en /sdcard (causa problemas de permisos en Android)
if [[ "$PROJECT_DIR" == /sdcard* ]] || [[ "$PROJECT_DIR" == /storage/emulated* ]]; then
  echo "⚠️  ADVERTENCIA IMPORTANTE:"
  echo "Estás ejecutando el bot en el almacenamiento externo ($PROJECT_DIR)."
  echo "En Android, /sdcard no soporta permisos de ejecución ni bloqueos SQLite."
  echo "Se recomienda encarecidamente clonar en el directorio interno de Termux (~):"
  echo "  cd ~ && git clone https://github.com/EthoSof/EthoBot.git && cd EthoBot"
  echo ""
  read -p "¿Deseas continuar de todos modos? (s/n): " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    exit 1
  fi
fi

echo "==> [1/5] Comprobando repositorios y paquetes de Termux..."
export DEBIAN_FRONTEND=noninteractive
pkg update -y -o Dpkg::Options::="--force-confold" 2>/dev/null || true

# Resolver posible conflicto entre nodejs-lts y nodejs en Termux
if dpkg -s nodejs-lts >/dev/null 2>&1; then
  echo "==> Reemplazando nodejs-lts por nodejs (versión completa)..."
  pkg uninstall -y nodejs-lts >/dev/null 2>&1 || true
fi

echo "==> [2/5] Instalando Node.js, git, ffmpeg y utilidades del sistema..."
pkg install -y -o Dpkg::Options::="--force-confold" nodejs git ffmpeg python openssl-tool termux-api yt-dlp 2>/dev/null || \
pkg install -y nodejs git ffmpeg python openssl-tool 2>/dev/null || \
pkg install -y nodejs git ffmpeg

# 2. Comprobar que Node.js esté disponible
if ! command -v node >/dev/null 2>&1; then
  echo "❌ ERROR: Node.js no pudo instalarse automáticamente."
  echo "Por favor ejecuta manualmente: pkg install -y nodejs"
  exit 1
fi

NODE_VER=$(node -v 2>/dev/null || echo "desconocida")
echo "==> Node.js $NODE_VER detectado y verificado."

# 3. Instalación limpia de dependencias npm
echo "==> [3/5] Instalando dependencias de Node.js (modo ligero para Termux)..."
mkdir -p data logs

# --omit=optional y --ignore-scripts evitan compilar binarios incompatibles como sharp o ffmpeg-static en Android
npm install --omit=dev --omit=optional --ignore-scripts --no-audit --no-fund || {
  echo "==> Reintentando con limpieza de caché..."
  npm install --omit=dev --omit=optional --ignore-scripts --no-audit --no-fund --force
}

# 4. Preparar configuración (.env)
echo "==> [4/5] Configurando variables de entorno (.env)..."
if [ ! -f .env ]; then
  if [ -f .env.example ]; then
    cp .env.example .env
  else
    touch .env
  fi

  SECRET=$(node -e "import('node:crypto').then(c => console.log(c.randomBytes(32).toString('hex')))" 2>/dev/null || node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
  ADMIN_PASS=$(node -e "import('node:crypto').then(c => console.log(c.randomBytes(9).toString('base64url')))" 2>/dev/null || node -e "console.log(require('crypto').randomBytes(9).toString('base64url'))")

  grep -q "^AUTH_SECRET=" .env 2>/dev/null && sed -i "s|^AUTH_SECRET=.*|AUTH_SECRET=$SECRET|" .env || echo "AUTH_SECRET=$SECRET" >> .env
  grep -q "^ADMIN_PASSWORD=" .env 2>/dev/null && sed -i "s|^ADMIN_PASSWORD=.*|ADMIN_PASSWORD=$ADMIN_PASS|" .env || echo "ADMIN_PASSWORD=$ADMIN_PASS" >> .env
  grep -q "^HOST=" .env 2>/dev/null && sed -i "s|^HOST=.*|HOST=127.0.0.1|" .env || echo "HOST=127.0.0.1" >> .env
  grep -q "^BOT_NAME=" .env 2>/dev/null && sed -i "s|^BOT_NAME=.*|BOT_NAME=Tanjiro Bot|" .env || echo "BOT_NAME=Tanjiro Bot" >> .env

  echo ""
  echo "=========================================================="
  echo "  ✅ Archivo .env creado correctamente"
  echo "=========================================================="
  echo "  Usuario Administrador: admin"
  echo "  Contraseña de acceso:  $ADMIN_PASS"
  echo "=========================================================="
else
  echo "==> El archivo .env ya existe. No se modificó para conservar tus datos."
fi

# 5. Permisos de ejecución en los scripts de control
echo "==> [5/5] Ajustando permisos de scripts..."
chmod +x scripts/termux-setup.sh scripts/termux-start.sh scripts/termux-stop.sh 2>/dev/null || true

echo ""
echo "=========================================================="
echo "  🎉 ¡Tanjiro Bot instalado y listo en Termux!"
echo "=========================================================="
echo "  ▶ Iniciar el bot:       bash scripts/termux-start.sh"
echo "  ▶ Ver consola en vivo:  bash scripts/termux-start.sh --foreground"
echo "  ▶ Ver registros/logs:   tail -f logs/bot.log"
echo "  ▶ Detener el bot:       bash scripts/termux-stop.sh"
echo "  ▶ Panel de control web: http://localhost:3000"
echo "=========================================================="
