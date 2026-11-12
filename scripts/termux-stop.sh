#!/data/data/com.termux/files/usr/bin/env bash
# ==============================================================
# Detiene Tanjiro Bot y libera el wake-lock de Termux
# Uso: bash scripts/termux-stop.sh
# ==============================================================
cd "$(dirname "$0")/.."

STOPPED=0

for pid_file in data/bot.pid data/tanjiro.pid data/etho.pid; do
  if [ -f "$pid_file" ]; then
    PID=$(cat "$pid_file" 2>/dev/null | tr -d '\r\n')
    if [ -n "$PID" ]; then
      pkill -P "$PID" 2>/dev/null || true
      kill "$PID" 2>/dev/null || true
      STOPPED=1
    fi
    rm -f "$pid_file"
  fi
done

# Búsqueda adicional de procesos huérfanos de Node en caso de que el PID haya cambiado
pkill -f "node.*src/index.js" 2>/dev/null && STOPPED=1 || true

if [ "$STOPPED" -eq 1 ]; then
  echo "✅ Tanjiro Bot detenido correctamente."
else
  echo "ℹ️ No se detectó ningún proceso activo de Tanjiro Bot."
fi

# Liberar Wake Lock para ahorrar batería
if command -v termux-wake-unlock >/dev/null 2>&1; then
  termux-wake-unlock || true
fi
