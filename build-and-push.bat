@echo off
REM ============================================================
REM  build-and-push.bat
REM  Builda a imagem e faz push para o Docker Hub (Windows)
REM ============================================================

SET /P DOCKER_USER="Digite seu usuario do Docker Hub: "
SET IMAGE_NAME=zendesk-dashboard
SET TAG=latest
SET FULL_IMAGE=%DOCKER_USER%/%IMAGE_NAME%:%TAG%

echo.
echo  ==========================================
echo   Zendesk Dashboard - Docker Push
echo  ==========================================
echo.
echo  Imagem: %FULL_IMAGE%
echo.

echo  Fazendo login no Docker Hub...
docker login
IF ERRORLEVEL 1 (echo  Erro no login. Abortando. && pause && exit /b 1)

echo.
echo  Buildando imagem para linux/amd64...
docker build --platform linux/amd64 -t %FULL_IMAGE% .
IF ERRORLEVEL 1 (echo  Erro no build. Abortando. && pause && exit /b 1)

echo.
echo  Enviando para Docker Hub...
docker push %FULL_IMAGE%
IF ERRORLEVEL 1 (echo  Erro no push. Abortando. && pause && exit /b 1)

echo.
echo  Pronto! Imagem disponivel em:
echo  https://hub.docker.com/r/%DOCKER_USER%/%IMAGE_NAME%
echo.
echo  Cole no Portainer (Stacks):
echo.
echo  services:
echo    zendesk-dashboard:
echo      image: %FULL_IMAGE%
echo      container_name: zendesk-dashboard
echo      ports:
echo        - "3737:3737"
echo      restart: unless-stopped
echo.
pause
