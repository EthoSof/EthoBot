@echo off
title Tanjiro Bot - Servidor
chcp 65001 > nul
echo ========================================================
echo  🚀 INICIANDO TANJIRO BOT (WHATSAPP AUTOMÁTICO)
echo ========================================================
echo.

node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js no está instalado o no se encuentra en el PATH.
    echo Por favor descarga e instala Node.js LTS desde https://nodejs.org/
    pause
    exit /b 1
)

if not exist .env (
    if exist .env.example copy .env.example .env >nul
)

echo [1/3] Verificando dependencias...
if not exist node_modules (
    echo Instalando paquetes necesarios (solo la primera vez)...
    call npm install
)

echo [2/3] Levantando servidor y vinculación en terminal...
echo.

:: Abrir navegador en 2 segundos en segundo plano si está disponible
start "" powershell -Command "Start-Sleep -Seconds 2; Start-Process 'http://localhost:3000'" 2>nul

:: Ejecutar el servidor (permite vincular directamente por código de 8 dígitos o QR)
npm start

