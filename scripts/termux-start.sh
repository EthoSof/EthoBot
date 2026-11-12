#!/data/data/com.termux/files/usr/bin/env bash
# ==============================================================
# Inicia Tanjiro Bot en Termux y evita que Android lo cierre
# Uso: bash scripts/termux-start.sh [--foreground]
# ==============================================================
cd "$(dirname "$0")/.."
mkdir -p data logs

# Verificar si ya existe una instancia activa
for pid_file in data/bot.pid data/tanjiro.pid data/etho.pid; do
  if [ -f "$pid_file" ]; then
    PID=$(cat "$pid_file" 2>/dev/null | tr -d '\r\n')
    if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
      echo "⚠️ Tanjiro Bot ya está en ejecución (PID $PID)."
      echo "Para detenerlo ejecuta: bash scripts/termux-stop.sh"
      exit 0
    fi
  fi
done

# Activar Wake Lock para que Android no duerma la CPU con la pantalla apagada
if command -v termux-wake-lock >/dev/null 2>&1; then
  termux-wake-lock
fi

export TERMUX_VERSION="${TERMUX_VERSION:-1}"
export TMPDIR="${TMPDIR:-${PREFIX:-/data/data/com.termux/files/usr}/tmp}"
mkdir -p "$TMPDIR"

# Modo primer plano (foreground) para ver la consola en vivo
if [ "$1" = "--foreground" ] || [ "$1" = "-f" ]; then
  exec npm run start:termux
fi

# Modo segundo plano (background con nohup)
nohup npm run start:termux >> logs/bot.log 2>&1 &
BOT_PID=$!
echo $BOT_PID > data/bot.pid
echo $BOT_PID > data/tanjiro.pid

sleep 3

if kill -0 "$BOT_PID" 2>/dev/null; then
  PORT=$(grep -E '^PORT=' .env 2>/dev/null | cut -d= -f2 | tr -d '\r\n')
  PORT=${PORT:-3000}
  echo ""
  echo "=========================================================="
  echo "  🚀 Tanjiro Bot iniciado con éxito (PID $BOT_PID)"
  echo "=========================================================="
  echo "  ▶ Panel Web:   http://localhost:$PORT"
  echo "  ▶ Ver logs:    tail -f logs/bot.log"
  echo "  ▶ Detener:     bash scripts/termux-stop.sh"
  echo "=========================================================="
else
  echo ""
  echo "❌ ERROR: El bot no pudo iniciar o se detuvo de inmediato."
  echo "Últimas líneas del registro (logs/bot.log):"
  echo "----------------------------------------------------------"
  tail -n 25 logs/bot.log 2>/dev/null || true
  echo "----------------------------------------------------------"
  echo "Prueba iniciarlo en primer plano para ver el error exacto:"
  echo "  bash scripts/termux-start.sh --foreground"
  exit 1
fi
