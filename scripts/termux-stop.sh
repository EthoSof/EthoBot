#!/data/data/com.termux/files/usr/bin/env bash
# Detiene Etho Bot y libera el wake-lock de Termux.
cd "$(dirname "$0")/.."
if [ -f data/etho.pid ]; then
  PID=$(cat data/etho.pid)
  # npm lanza node como hijo: se detiene el grupo completo
  pkill -P "$PID" 2>/dev/null
  kill "$PID" 2>/dev/null && echo "Etho Bot detenido."
  rm -f data/etho.pid
else
  echo "No hay un proceso guardado."
fi
command -v termux-wake-unlock >/dev/null 2>&1 && termux-wake-unlock
