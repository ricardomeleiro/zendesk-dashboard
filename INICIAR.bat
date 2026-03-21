@echo off
echo.
echo  ==========================================
echo   Zendesk Dashboard - Proxy Local
echo  ==========================================
echo.
echo  Verificando Node.js...
node --version >nul 2>&1
IF ERRORLEVEL 1 (
  echo  ERRO: Node.js nao encontrado!
  echo  Baixe em: https://nodejs.org
  pause
  exit
)
echo  Node.js OK!
echo.
echo  Instalando dependencias (primeira vez)...
call npm install
echo.
echo  Iniciando proxy...
echo  Acesse: http://localhost:3737
echo.
node server.js
pause
