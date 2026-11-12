# Ejecutar Tanjiro Bot en Termux (Android)

Funciona con Termux instalado preferiblemente desde **F-Droid** (la versión de Google Play Store está obsoleta).

## Instalación en 1 paso

Dentro de Termux, ejecuta el comando de instalación automática:

```bash
pkg install -y git && git clone https://github.com/EthoSof/EthoBot.git && cd EthoBot
bash scripts/termux-setup.sh
```

El script se encarga de:
1. Instalar y configurar Node.js, git, ffmpeg, python y utilidades.
2. Resolver automáticamente cualquier conflicto previo de paquetes (`nodejs-lts`).
3. Instalar las dependencias de Node optimizadas para Android (sin binarios pesados ni módulos nativos innecesarios).
4. Generar el archivo `.env` con contraseñas seguras y dejar el panel listo en `http://localhost:3000`.

---

## Comandos de Uso Diario

| Acción | Comando |
| --- | --- |
| **Iniciar en segundo plano** | `bash scripts/termux-start.sh` |
| **Ver registros en vivo (logs)** | `tail -f logs/bot.log` |
| **Iniciar en consola (primer plano)** | `bash scripts/termux-start.sh --foreground` |
| **Detener el bot** | `bash scripts/termux-stop.sh` |

El panel web estará disponible en `http://localhost:3000` desde el navegador de tu teléfono.

---

## Vincular WhatsApp

Como no puedes escanear un código QR desde la misma pantalla del teléfono:
1. Abre `http://localhost:3000` en tu navegador.
2. Al añadir o editar tu bot, selecciona la opción **Vincular con código**.
3. Ingresa tu número de teléfono (con código de país, sin signos ni espacios, ej: `573001234567`).
4. El panel generará un código de 8 dígitos.
5. En WhatsApp ve a: **Ajustes / Configuración → Dispositivos vinculados → Vincular con número de teléfono** e introduce el código.

---

## Evitar que Android cierre Termux

Para que el bot funcione 24/7 sin interrupciones:
1. **Ajustes de Android → Aplicaciones → Termux → Batería**: ponlo en **Sin restricciones**.
2. Instala la aplicación **Termux:API** (desde F-Droid) y el script usará `termux-wake-lock` automáticamente para mantener la CPU activa con la pantalla apagada.
3. No deslices ni cierres la notificación permanente de Termux en la barra de estado.

---

## Actualizar a la última versión

```bash
bash scripts/termux-stop.sh
git pull
npm install --omit=dev --omit=optional --ignore-scripts
bash scripts/termux-start.sh
```
