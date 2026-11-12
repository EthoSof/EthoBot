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

## Vincular WhatsApp (desde la terminal, sin navegador)

La primera vez que inicias el bot (`npm start` o `bash scripts/termux-start.sh`), la terminal te pregunta cómo vincularlo:

1. Elige **1) Código de 8 dígitos** (pulsa Enter).
2. Escribe el número de WhatsApp del bot con código de país, sin `+` ni espacios (ej: `573001234567`).
3. La terminal muestra un código como `ABCD-EFGH`.
4. En WhatsApp ve a: **Ajustes → Dispositivos vinculados → Vincular un dispositivo → Vincular con el número de teléfono** e introduce el código.
5. Cuando la terminal diga **¡LISTO!**, el bot ya responde. Pruébalo escribiendo `#menu`.

Si el código caduca, se genera otro automáticamente. La sesión queda guardada: las siguientes veces solo ejecutas el comando y el bot se conecta solo.

También puedes hacerlo desde el panel (`http://localhost:3000` → tu bot → **Vincular con código**), o definir `PAIRING_NUMBER=573001234567` en `.env` para que muestre el código sin preguntar.

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
