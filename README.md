# TANJIRO BOT - MULTI-BOT HUB & DASHBOARD PRO

Sistema integral de WhatsApp: **Backend (Node.js 22.13+ y Baileys Multi-Instancia) + Frontend Web Reactivo SaaS + Almacenamiento Local Nativo (Zero Config)**.

Permite desplegar y controlar múltiples bots con diferentes números desde un panel visual ejecutivo, ver el código QR en vivo para vincular WhatsApp, crear bots con 4 facetas (Recreativo, Asistente, Asesor, IA Autónoma), gestionar catálogo de productos, capturar prospectos (CRM Leads), horarios de atención, transferencia a asesor humano (#asesor), probar en el simulador de chat en vivo y registrar toda la actividad en tiempo real.

---

## 📱 Ejecutar en Termux (Android)

```bash
pkg install -y git && git clone https://github.com/EthoSof/EthoBot.git && cd EthoBot
bash scripts/termux-setup.sh   # instala todo y crea el .env
bash scripts/termux-start.sh   # inicia en segundo plano
```

Panel en `http://localhost:3000`. Guía completa en [docs/TERMUX.md](docs/TERMUX.md).

---

## 🌟 Características Principales

### 1. 🏛️ Panel de Control SaaS (Web Dashboard)
- Acceso desde cualquier navegador en `http://localhost:3000`.
- Diseño **Executive SaaS** con barra lateral (*Sidebar*), migas de pan (*Breadcrumbs*), modo oscuro (*Dark Mode*) y 100% responsivo para móviles con barra inferior táctil.
- Estado del servidor en tiempo real mediante **Server-Sent Events (SSE)**.

### 2. 🎭 Wizard de Creación con 4 Facetas de Bot
- **🎮 Recreativo & Grupos (Estilo Etho)**: Los 219 comandos de economía, ruleta, anime, gacha, stickers y juegos.
- **💼 Asistente Personal**: Tareas, notas, recordatorios y productividad personal.
- **🛍️ Asesor Comercial & Ventas**: Atención a clientes 24/7, catálogo interactivo (`#catalogo`), horarios y captura de prospectos.
- **🧠 Bot Autónomo con IA**: Conversa por sí mismo en chats y menciones sin necesidad de prefijos ni comandos.

### 3. 💼 CRM de Prospectos (Leads) con Exportación CSV
- Captura automática de interesados cuando un cliente escribe su correo, teléfono o solicita información comercial.
- Tabla interactiva con filtro por estado (*Nuevo*, *Contactado*, *Ganado*, *Perdido*).
- Botón **Descargar Excel (CSV)** con 1 clic.

### 4. 🛍️ Catálogo Digital de Productos & Servicios
- Registra productos con foto, categoría, precio y moneda.
- Comando automático en WhatsApp **`#catalogo`**: el bot genera y envía el menú interactivo con precios.

### 5. 🕒 Horarios Comerciales y Transferencia a Humano (Human Handoff)
- **Horarios de Atención**: Define días y horas laborales. Fuera de horario, el bot envía un mensaje automático de cortesía.
- **Transferencia a Asesor Humano**: Si el cliente escribe `#asesor`, `#humano` o `#soporte`, el bot le avisa y **pausa sus respuestas automáticamente** durante el tiempo configurado para permitir atención personalizada.

### 6. 💬 Simulador de Chat Estilo WhatsApp (Playground)
- Ventana interactiva en el navegador que simula una conversación con el bot.
- Evalúa tanto las reglas dinámicas personalizadas como la IA antes de conectar un número real.

### 7. 🎯 Creador de Reglas y Funciones Dinámicas (Sin Código)
- Crea comandos personalizados (`#promo`), texto exacto o palabras clave.
- Variables dinámicas: `{user}` (etiqueta al usuario), `{name}` (nombre), `{date}`, `{time}`, `{bot}`.

### 8. ⚡ Almacenamiento Local Autónomo (Zero Config)
- Funciona directamente sin requerir configurar bases de datos externas ni cuentas de terceros.
- Base de datos SQLite local rápida y persistente en `data/bot.db`.

---

## 📦 Matriz General de Dependencias

Para que cada comando funcione al 100%, esta es la lista de dependencias y requerimientos:

| Componente | Tipo | Necesario Para | ¿Cómo se instala? |
|---|---|---|---|
| **Node.js 20+ / 22+** | Runtime | Núcleo del servidor, API y bots | `pkg install nodejs` (Termux) o [nodejs.org](https://nodejs.org) |
| **Baileys (WhatsApp Web)** | Librería NPM | Conexión WebSocket y eventos de WhatsApp | Se instala automáticamente con `npm install` |
| **FFmpeg** | Binario de Sistema | Conversión de audio/video y stickers (`#sticker`, `#play`, `#mp4`) | `pkg install ffmpeg` (Termux) / `apt install ffmpeg` |
| **yt-dlp** | Binario de Sistema | Descargas de YouTube, TikTok, Facebook, Reels, Twitter | `pkg install yt-dlp` (Termux) o `python -m pip install yt-dlp` |
| **SQLite (node:sqlite)** | Nativo Node | Guardar perfiles, bots, economía, inventario, CRM y logs | Incluido nativamente en Node.js (Zero Config) |
| **Google Gemini API Key** | Clave de API *(Opcional)* | Respuestas de IA ultra inteligentes y transcripción | `GEMINI_API_KEY` en `.env` (si falta, usa motor cognitivo local) |
| **Permisos de Admin** | Permiso WhatsApp | Comandos grupales (`#kick`, `#promote`, `#open`, `#antilink`) | El bot debe ser Administrador del grupo |
| **Número Owner** | Configuración | Comandos de control (`#piloto`, `#backup`, `#broadcast`, `#ban`) | `OWNER_NUMBERS` en `.env` |

---

## 📜 Catálogo Completo de Comandos (125 Comandos Únicos)

El prefijo por defecto es `#` (configurable en `.env` o en cada bot).

### 1. 💼 Productividad e Inteligencia Artificial (14 comandos)
> **Dependencias:** `qrcode`, `axios`. Opcional: `GEMINI_API_KEY` en `.env` para IA generativa en la nube (si no se proporciona, responde el motor cognitivo local).

| Comando | Parámetros / Uso | Alias | Descripción |
|---|---|---|---|
| `#ia` | `[mensaje]` | `#preguntar`, `#chat` | Consulta al Asistente Inteligente con IA de razonamiento continuo. |
| `#resetia` | *Ninguno* | `#olvidar`, `#borrarmemoria` | Borra la memoria contextual de conversación en este chat. |
| `#calc` | `[operación]` | `#calcular` | Resuelve operaciones y expresiones matemáticas. |
| `#clima` | `[ciudad]` | `#weather`, `#tiempo` | Consulta el clima en tiempo real, temperatura y pronóstico. |
| `#wiki` | `[tema]` | `#wikipedia` | Busca y resume artículos enciclopédicos de Wikipedia. |
| `#traducir` | `[idioma] [texto]` | `#tr`, `#translate` | Traduce texto al idioma deseado (`es`, `en`, `fr`, `pt`, `ja`, etc.). |
| `#qr` | `[texto o enlace]` | `#codigoqr` | Genera y envía un código QR de alta resolución. |
| `#acortar` | `[enlace]` | `#short` | Acorta URLs largas para hacerlas más estéticas y compartibles. |
| `#hora` | `<Zona/Ciudad>` | `#time` | Informa la hora exacta en cualquier zona horaria mundial. |
| `#recordar` | `[10m\|2h\|1d] [texto]` | `#remind`, `#recordatorio` | Programa un recordatorio personal que el bot te avisará a tiempo. |
| `#nota` | `[add texto \| list \| del id]` | `#notas`, `#note` | Bloc de notas personal persistente en SQLite. |
| `#encuesta` | `[pregunta] \| [op1] \| [op2]` | `#poll` | Genera una encuesta nativa e interactiva de WhatsApp. |
| `#afk` | `<motivo>` | *Ninguno* | Te marca como ausente; avisa a quien te mencione en grupos. |
| `#pass` | `<longitud>` | `#password`, `#clave` | Genera una contraseña segura, aleatoria y de alta entropía. |

---

### 2. 🛡️ Administración y Moderación de Grupos (28 comandos)
> **Dependencias:** El bot debe ser **Administrador del grupo** en WhatsApp para ejecutar sanciones y cambios de ajustes.

| Comando | Parámetros / Uso | Alias | Descripción |
|---|---|---|---|
| `#listadmins` | *Ninguno* | `#admins` | Lista con mención a todos los administradores del grupo actual. |
| `#rules` | *Ninguno* | `#reglas` | Muestra el reglamento oficial del grupo. |
| `#setrules` | `[texto]` | *Ninguno* | Guarda o actualiza las reglas del grupo. |
| `#antilink` | `[on/off]` | `#antienlace` | Expulsa automáticamente a miembros que envíen enlaces de grupos. |
| `#antispam` | `[on/off]` | *Ninguno* | Protección contra saturación de mensajes repetitivos y flood. |
| `#bot` | `[on/off]` | *Ninguno* | Activa o desactiva temporalmente el bot en este grupo. |
| `#economy` | `[on/off]` | `#economia` | Habilita o bloquea el uso de monedas y juegos en el grupo. |
| `#gacha` | `[on/off]` | *Ninguno* | Habilita o deshabilita los comandos de gacha y personajes. |
| `#goodbye` | `[on/off]` | `#despedida` | Enciende o apaga el mensaje de despedida al salir miembros. |
| `#welcome` | `[on/off]` | `#bienvenida` | Enciende o apaga el mensaje de bienvenida al entrar miembros. |
| `#nsfw` | `[on/off]` | *Ninguno* | Activa o bloquea comandos clasificados para adultos (+18). |
| `#onlyadmin` | `[on/off]` | `#onlyadmins` | Permite que únicamente administradores puedan usar el bot. |
| `#open` | *Ninguno* | *Ninguno* | Abre el grupo para que todos los participantes puedan hablar. |
| `#close` | *Ninguno* | *Ninguno* | Cierra el grupo permitiendo escribir solo a administradores. |
| `#kick` | `[@mención \| {mensaje}]` | *Ninguno* | Expulsa a un participante del grupo. |
| `#promote` | `[@mención \| {mensaje}]` | *Ninguno* | Promueve a un participante al rango de Administrador. |
| `#demote` | `[@mención \| {mensaje}]` | *Ninguno* | Degrada a un Administrador a miembro regular. |
| `#groupimage` | `{responder con imagen}` | `#groupimg`, `#gpimg`, `#setgroupimage` | Cambia el icono / foto de perfil del grupo de WhatsApp. |
| `#setwelcome` | `[texto]` | *Ninguno* | Personaliza el saludo de bienvenida (variables: `{user}`, `{group}`). |
| `#setgoodbye` | `[texto]` | *Ninguno* | Personaliza el texto de despedida al salir alguien. |
| `#setwarnlimit` | `<cantidad>` | *Ninguno* | Define el tope de advertencias antes de expulsar (por defecto 3). |
| `#warn` | `[@mención] <razón>` | *Ninguno* | Aplica una advertencia formal por faltas al reglamento. |
| `#warns` | `[@mención]` | *Ninguno* | Consulta el historial y conteo de advertencias de un usuario. |
| `#delwarn` | `[@mención] [número]` | *Ninguno* | Remueve una advertencia aplicada previamente a un usuario. |
| `#tag` | `[texto \| {mensaje}]` | `#hidetag`, `#tagsay`, `#tagall` | Menciona de forma invisible a todos los integrantes del grupo. |
| `#msgcount` | `<@mención> <días>` | `#count`, `#messages`, `#mensajes` | Cuenta los mensajes enviados por un miembro en un período. |
| `#topcount` | `<días>` | `#topmessages`, `#topmensajes` | Ranking de los participantes más activos en el chat grupal. |
| `#topinactive`| `<página> <días>` | `#topinactivos`, `#topinactiveusers` | Detecta los miembros con menor interacción para depuración. |

---

### 3. 📥 Descargas y Multimedia de Redes Sociales (7 comandos)
> **Dependencias:** `ffmpeg` y `yt-dlp` instalados en el sistema (`pkg install ffmpeg yt-dlp` en Termux o Linux).

| Comando | Parámetros / Uso | Alias | Descripción |
|---|---|---|---|
| `#play` | `[búsqueda \| enlace]` | `#yt`, `#ytaudio`, `#playaudio`, `#ethoplay` | Descarga el audio de YouTube en formato MP3 o nota de voz. |
| `#mp4` | `[búsqueda \| enlace]` | `#ytmp4`, `#mp4doc` | Descarga un video de YouTube en MP4 (o documento descargable). |
| `#ytsearch` | `[búsqueda]` | `#search` | Busca videos en YouTube mostrando título, duración y canales. |
| `#tiktok` | `[enlace]` | `#tt` | Descarga videos de TikTok en alta calidad y sin marca de agua. |
| `#facebook` | `[enlace]` | `#fb` | Descarga videos públicos compartidos en Facebook. |
| `#reel` | `[enlace]` | `#ig`, `#instagram` | Descarga Reels, videos y publicaciones de Instagram. |
| `#twitter` | `[enlace]` | `#x` | Descarga videos y clips publicados en Twitter / X. |

---

### 4. 🎨 Multimedia y Creación de Stickers (14 comandos)
> **Dependencias:** `ffmpeg` instalado en el sistema para renderizado WebP 512x512.

| Comando | Parámetros / Uso | Alias | Descripción |
|---|---|---|---|
| `#sticker` | `{imagen/video} <pack> \| <autor>` | `#s`, `#stickers` | Convierte una imagen, GIF o video corto en sticker de WhatsApp. |
| `#setstickermeta` | `[paquete] \| <autor>` | `#setmeta` | Establece el nombre de paquete y autor por defecto para tus stickers. |
| `#delstickermeta` | *Ninguno* | `#delmeta` | Restablece tus metadatos personales de stickers. |
| `#newpack` | `[paquete]` | `#newstickerpack` | Crea una colección o álbum de stickers propio en la base de datos. |
| `#delpack` | `[paquete]` | *Ninguno* | Elimina uno de tus álbumes de stickers existentes. |
| `#stickerpacks` | *Ninguno* | `#packlist` | Muestra la lista de colecciones de stickers creadas por ti. |
| `#stickeradd` | `{sticker} [paquete]` | `#addsticker` | Guarda un sticker de WhatsApp dentro de uno de tus paquetes. |
| `#stickerdel` | `{sticker} [paquete]` | `#delsticker` | Remueve un sticker guardado de una colección. |
| `#getpack` | `[paquete \| slug]` | `#stickerpack`, `#pack` | Envía secuencialmente todos los stickers de un paquete. |
| `#setpackpublic` | `[paquete]` | `#setpackpub`, `#packpublic` | Publica una colección para que otros usuarios puedan usarla con su slug. |
| `#setpackprivate`| `[paquete]` | `#setpackpriv`, `#packprivate`| Vuelve privada una colección de stickers compartida. |
| `#setstickerpackdesc` | `[paquete] \| [desc]` | `#setpackdesc`, `#packdesc` | Añade una descripción informativa a un álbum de stickers. |
| `#packfavourite`| `[slug]` | `#setpackfav`, `#packfav` | Guarda un paquete comunitario en tu lista de favoritos. |
| `#packunfavourite`| `[slug]` | `#unsetpackfav`, `#packunfav`| Quita un paquete comunitario de tu lista de favoritos. |

---

### 5. 💰 Comunidad y Economía Virtual (12 comandos)
> **Dependencias:** Almacenamiento local SQLite (sin dependencias externas).

| Comando | Parámetros / Uso | Alias | Descripción |
|---|---|---|---|
| `#balance` | `<@mención>` | `#bal`, `#coins` | Consulta las monedas que llevas en mano y las guardadas en el banco. |
| `#daily` | *Ninguno* | *Ninguno* | Reclama tu recompensa diaria de monedas con racha acumulativa. |
| `#work` | *Ninguno* | `#w` | Trabaja en diferentes oficios para conseguir ingresos periódicos. |
| `#crime` | *Ninguno* | *Ninguno* | Ejecuta crímenes de alto riesgo/recompensa con probabilidad de cárcel/multa. |
| `#deposit` | `[cantidad \| all]` | `#dep`, `#depositar`, `#d` | Guarda tus monedas en el banco para protegerlas de robos. |
| `#withdraw` | `[cantidad \| all]` | `#with`, `#retirar` | Retira monedas de tu cuenta bancaria a tu billetera activa. |
| `#givecoins` | `[@mención] [cantidad]` | `#pay`, `#coinsgive` | Transfiere monedas de tu saldo a otro miembro de la comunidad. |
| `#steal` | `[@mención]` | `#robar`, `#rob` | Intenta hurtar monedas a otro usuario (con riesgo de ser multado). |
| `#roulette` | `[red/black] [cantidad]` | `#rt` | Apuesta tus monedas al rojo o al negro en la ruleta de casino. |
| `#coinflip` | `[cantidad] <cara/cruz>` | `#flip`, `#cf` | Lanza una moneda al aire y duplica tus monedas si aciertas. |
| `#economyboard` | `<página>` | `#eboard`, `#baltop` | Ranking global de los miembros más ricos del servidor. |
| `#economyinfo` | *Ninguno* | `#einfo` | Información de estadísticas económicas, topes y multiplicadores. |

---

### 6. 🎲 Dinámicas y Minijuegos (8 comandos)
> **Dependencias:** Ninguna (módulo recreativo local nativo).

| Comando | Parámetros / Uso | Alias | Descripción |
|---|---|---|---|
| `#slots` | `[apuesta \| all]` | `#tragamonedas`, `#slot` | Máquina tragamonedas con combinaciones y jackpots especiales. |
| `#ppt` | `[piedra\|papel\|tijera]` | `#rps` | Partida de piedra, papel o tijera contra Tanjiro Bot. |
| `#dado` | `<caras>` | `#dice`, `#roll6` | Lanza un dado de cualquier número de caras (ej: d6, d20, d100). |
| `#8ball` | `[pregunta]` | `#bola8`, `#pregunta` | Hazle una pregunta existencial a la bola mágica interactiva. |
| `#ship` | `[@a] [@b]` | *Ninguno* | Calcula el porcentaje de afinidad amorosa entre dos miembros. |
| `#trivia` | *Ninguno* | *Ninguno* | Genera una pregunta de trivia interactiva de cultura general. |
| `#responder` | `[a\|b\|c\|d]` | `#r` | Responde a la pregunta de trivia activa para ganar monedas. |
| `#suerte` | *Ninguno* | `#luck` | Consulta tu horóscopo y nivel de suerte del día. |

---

### 7. 👤 Perfiles Sociales y Niveles (16 comandos)
> **Dependencias:** Almacenamiento local SQLite.

| Comando | Parámetros / Uso | Alias | Descripción |
|---|---|---|---|
| `#profile` | `<@mención>` | *Ninguno* | Muestra la tarjeta de perfil con rango, monedas, nivel y pareja. |
| `#level` | `<@mención>` | `#lvl` | Muestra tu nivel de experiencia (EXP) y progreso al siguiente rango. |
| `#leaderboard` | `<página>` | `#lboard`, `#top` | Tabla de clasificación de los usuarios con mayor experiencia. |
| `#setdescription`| `<descripción>` | `#setdesc` | Configura una frase o biografía personal en tu perfil. |
| `#setbirth` | `[DD/MM/AAAA]` | *Ninguno* | Registra tu fecha de nacimiento en el sistema. |
| `#delbirth` | *Ninguno* | *Ninguno* | Elimina tu fecha de cumpleaños del perfil. |
| `#birthdays` | *Ninguno* | `#cumpleaños`, `#births` | Lista los cumpleaños más próximos de los miembros. |
| `#allbirthdays` | *Ninguno* | `#allbirths` | Muestra el calendario completo de cumpleaños registrados. |
| `#setgenre` | `[hombre \| mujer \| otro]` | *Ninguno* | Especifica tu género para la ficha de perfil. |
| `#delgenre` | *Ninguno* | *Ninguno* | Elimina el dato de género de tu perfil. |
| `#setfavourite` | `[nombre]` | `#setfav` | Fija tu personaje reclamado favorito en tu tarjeta de perfil. |
| `#delfavourite` | *Ninguno* | `#delfav` | Remueve tu personaje favorito de la portada. |
| `#marry` | `[@mención]` | `#casarse` | Envía una propuesta de matrimonio virtual a otro participante. |
| `#divorce` | *Ninguno* | *Ninguno* | Disuelve el matrimonio virtual actual con tu pareja. |
| `#marryhistory` | `<@mención>` | `#marriagehistory`, `#historialmatrimonio` | Historial genealógico de bodas y divorcios del usuario. |
| `#group` | *Ninguno* | `#gp`, `#groupinfo` | Muestra la información, fecha de creación e id técnico del grupo. |

---

### 8. 👑 Control y Exclusivos de Propietario (9 comandos)
> **Dependencias:** El número del remitente debe figurar en la variable `OWNER_NUMBERS` en `.env`.

| Comando | Parámetros / Uso | Alias | Descripción |
|---|---|---|---|
| `#piloto` | `[on\|off\|modo\|contexto]`| `#autopilot`, `#hablarpormi` | Configura el Piloto Automático con IA para que hable y atienda por el dueño. |
| `#recados` | *Ninguno* | `#mensajesrecibidos` | Consulta recados y mensajes de clientes capturados mientras no estabas. |
| `#personalidad` | *Ninguno* | `#persona`, `#tono` | Ajusta las directivas de personalidad, tono y comportamiento del bot. |
| `#palabras` | *Ninguno* | `#words`, `#filtro` | Administra la lista negra de palabras censuradas y términos preferidos. |
| `#broadcast` | `[texto]` | `#bc` | Envía un comunicado masivo con formato oficial a todos los grupos. |
| `#backup` | *Ninguno* | *Ninguno* | Genera y te envía un respaldo descargable del archivo `bot.db`. |
| `#ban` | `[@mención]` | *Ninguno* | Agrega a un usuario a la lista negra global del bot. |
| `#unban` | `[@mención]` | *Ninguno* | Remueve el bloqueo global a un usuario sancionado. |
| `#addcoins` | `[@mención] [cantidad]` | *Ninguno* | Genera y acredita monedas directamente al saldo de un usuario. |

---

### 9. ⚙️ Utilidades del Sistema (17 comandos)
> **Dependencias:** Baileys y Node.js.

| Comando | Parámetros / Uso | Alias | Descripción |
|---|---|---|---|
| `#menu` | `<categoría>` | `#help`, `#comandos`, `#commands`, `#ayuda`, `#tanjiro`, `#etho` | Despliega el menú principal interactivo de comandos disponibles. |
| `#ping` | *Ninguno* | `#p` | Mide la velocidad de respuesta en milisegundos del bot. |
| `#status` | *Ninguno* | *Ninguno* | Reporta uso de memoria RAM, uptime del sistema y estado de sockets. |
| `#botinfo` | *Ninguno* | `#infobot` | Información técnica de arquitectura, versión y plataforma. |
| `#bots` | *Ninguno* | `#sockets` | Cantidad de instancias y líneas de bot activas en el Hub. |
| `#del` | `{responder a mensaje}`| `#delete` | Elimina mensajes del bot (o de otros usuarios si el bot es admin). |
| `#getpic` | `[@mención \| {mensaje}]`| `#pfp` | Descarga la foto de perfil en máxima resolución de un usuario. |
| `#toimage` | `{responder a sticker}`| `#toimg` | Convierte un sticker de WhatsApp nuevamente en una imagen JPG/PNG. |
| `#suggest` | `[texto]` | `#addanime`, `#report` | Envía una sugerencia de función o reporte de error al panel admin. |
| `#testwelcome` | *Ninguno* | `#testgoodbye` | Simula y envía la tarjeta de bienvenida o despedida configurada. |
| `#join` | `[enlace]` | *Ninguno* | Ordena al bot ingresar a un grupo mediante su enlace de invitación (Dueño). |
| `#invite` | *Ninguno* | *Ninguno* | Extrae el enlace de invitación del grupo actual. |
| `#leave` | *Ninguno* | `#salir` | Hace que el bot salga ordenadamente del grupo actual. |
| `#setname` | `[nombre]` | `#setbotname` | Modifica el nombre de perfil de WhatsApp de la línea del bot. |
| `#setstatus` | `[estado]` | *Ninguno* | Modifica la información / estado textual de la línea de WhatsApp. |
| `#setpfp` | `{responder con imagen}`| `#setimage` | Actualiza la foto de perfil de WhatsApp del bot. |
| `#mimo` | *Ninguno* | `#acariciar`, `#pet`, `#saludo` | Interacción de afecto con el bot. |

---

## 📁 Estructura del repositorio

```
src/
  index.js          Punto de entrada (servidor + bots)
  server.js         API REST, SSE y autenticación
  manager.js        Gestor multi-instancia de Baileys
  handler.js        Procesamiento de mensajes
  db.js             Almacenamiento local SQLite (node:sqlite)
  commands/         Comandos por categoría
  lib/              IA, auth, planes, facturación, tickets, mantenimiento, utilidades
  routes/           Rutas de pagos y de tickets
  web/public/       Frontend (único origen: index.html, app.js, style.css, PWA)
scripts/            check.js (valida comandos), banner.js
docs/DEPLOY.md      Guía de despliegue
```

## 💬 Estilo de los mensajes

- **Respuestas de IA:** se convierten al formato nativo de WhatsApp (`*negrita*`, `_cursiva_`, viñetas `•`), sin títulos `#`, tablas ni `**`. Está en `src/lib/format.js`.
- **Envío natural:** el bot muestra "escribiendo…" con una pausa proporcional al largo y parte los textos largos por párrafos.
- **Comandos:** encabezado compacto (`*🎵 #play* · _Multimedia_`) definido en `skin()` de `src/lib/ui.js`; los separadores (`SEP_*`) están ahí mismo.
- **Tono:** el prompt pide respuestas breves (2 a 5 líneas), máximo 2 emojis y una sola pregunta de cierre.
- **Menú y avisos:** formato compacto (una línea por comando) y tarjetas uniformes con `card()` en `src/lib/ui.js`. Los errores técnicos ya no se muestran en el chat (solo en los logs).
- **Comunicación de la IA** (`src/lib/ai-quality.js`): protocolo de 10 reglas (directo, sin repetir saludos, una sola pregunta, no inventar datos), responde en el idioma de la persona, resiste intentos de cambiarle las instrucciones, recorta historiales largos, corta siempre en una oración completa y usa un disyuntor para no esperar a proveedores caídos.
- `npm test` valida formato, IA, mensajes, planes, pagos, rutas y mantenimiento.

## 💳 Planes, pagos y soporte

- **Cuenta gratuita:** 7 días de uso y máximo 3 bots. Más tiempo o más bots requiere un plan de pago.
- **Pagos:** tarjeta con Stripe Checkout (activación solo por webhook firmado) y transferencia con aprobación manual. Ver **[docs/PAYMENTS.md](docs/PAYMENTS.md)**.
- **Tickets:** botón *Reportar error* en la landing (sin cuenta) y bandeja *Soporte & Tickets* en el panel.
- **Ideas a futuro:** [docs/ROADMAP.md](docs/ROADMAP.md).

## ✅ Producción

Antes de abrir al público revisa **[docs/PRODUCTION.md](docs/PRODUCTION.md)** y ejecuta `BASE_URL=https://tu-dominio.com npm run smoke` contra tu servidor desplegado.

## ☁️ Despliegue

Consulta **[docs/DEPLOY.md](docs/DEPLOY.md)** (Render, Railway, Docker/VPS y PM2).

## 🚀 Inicio Rápido en Windows

Simplemente haz doble clic en el archivo:
👉 **`iniciar.bat`**

Este archivo verificará dependencias, iniciará el servidor y abrirá `http://localhost:3000` en tu navegador automáticamente.

---

## 🛠️ Ejecución Manual

```bash
# 1. Instalar dependencias
npm install

# 2. Iniciar servidor
npm start
```

En el primer arranque se crea el usuario admin; si no defines `ADMIN_PASSWORD` en `.env`, la contraseña generada aparece en la consola.

Panel disponible en: **`http://localhost:3000`**

---

## 📱 Cómo Vincular un Bot de WhatsApp

1. Abre el panel en `http://localhost:3000`.
2. Haz clic en **`+ Nuevo Bot`**.
3. Elige la **Faceta** (*Recreativo, Asistente, Asesor, IA Autónoma*) y nómbralo.
4. En la tarjeta creada, haz clic en **`Escanear QR`**.
5. Abre **WhatsApp** en tu teléfono > **Dispositivos vinculados** > **Vincular dispositivo** y escanea el código en pantalla.
6. ¡Listo! El bot cambiará su estado a **En Línea** y comenzará a responder.

> En un servidor sin navegador (VPS, Docker, Termux) el QR también se imprime en la consola/logs; desactívalo con `QR_IN_TERMINAL=false`.
