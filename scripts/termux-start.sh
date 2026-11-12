#!/data/data/com.termux/files/usr/bin/env bash
# Inicia Etho Bot en segundo plano dentro de Termux y evita que Android lo duerma.
# Uso:  bash scripts/termux-start.sh [--foreground]
cd "$(dirname "$0")/.."
mkdir -p data logs

if [ -f data/etho.pid ] && kill -0 "$(cat data/etho.pid)" 2>/dev/null; then
  echo "Etho Bot ya está en marcha (PID $(cat data/etho.pid)). Para reiniciar: bash scripts/termux-stop.sh"
  exit 0
fi

# Mantiene la CPU despierta con la pantalla apagada (requiere la app Termux:API o Termux actualizado).
command -v termux-wake-lock >/dev/null 2>&1 && termux-wake-lock

export TERMUX_VERSION="${TERMUX_VERSION:-1}"
export TMPDIR="${TMPDIR:-${PREFIX:-/data/data/com.termux/files/usr}/tmp}"
mkdir -p "$TMPDIR"

if [ "$1" = "--foreground" ]; then
  exec npm run start:termux
fi

nohup npm run start:termux >> logs/etho.log 2>&1 &
echo $! > data/etho.pid
sleep 3
if kill -0 "$(cat data/etho.pid)" 2>/dev/null; then
  PORT=$(grep -E '^PORT=' .env 2>/dev/null | cut -d= -f2); PORT=${PORT:-3000}
  echo "Etho Bot iniciado (PID $(cat data/etho.pid))."
  echo "Panel: http://localhost:$PORT  (ábrelo en el navegador del teléfono)"
  echo "Registros: tail -f logs/etho.log"
else
  echo "No pudo iniciar. Revisa: tail -n 50 logs/etho.log"
  exit 1
fi
