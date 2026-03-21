#!/bin/bash
# ============================================================
#  build-and-push.sh
# ============================================================

set -e

# ── Localiza o Docker automaticamente ────────────────────────
find_docker() {
  for path in \
    "$(which docker 2>/dev/null)" \
    "/usr/local/bin/docker" \
    "/usr/bin/docker" \
    "/opt/homebrew/bin/docker" \
    "$HOME/.docker/bin/docker" \
    "/Applications/Docker.app/Contents/Resources/bin/docker"; do
    if [ -x "$path" ] 2>/dev/null; then
      echo "$path"
      return 0
    fi
  done
  return 1
}

DOCKER=$(find_docker || true)

if [ -z "$DOCKER" ]; then
  echo ""
  echo "  ❌ Docker não encontrado!"
  echo ""
  echo "  Possíveis soluções:"
  echo ""
  echo "  1) Docker Desktop não está ABERTO — abra o app e tente novamente."
  echo ""
  echo "  2) Adicione o Docker ao PATH e tente novamente:"
  echo "     Mac/Linux (cole no terminal):"
  echo "       export PATH=\"\$PATH:/usr/local/bin:/opt/homebrew/bin:\$HOME/.docker/bin\""
  echo ""
  echo "  3) Ou rode os comandos manualmente (veja abaixo):"
  echo ""
  echo "  ── COMANDOS MANUAIS ──────────────────────────────────"
  echo "  Substitua SEU_USUARIO pelo seu usuario do Docker Hub:"
  echo ""
  echo "    docker login"
  echo "    docker build --platform linux/amd64 -t SEU_USUARIO/zendesk-dashboard:latest ."
  echo "    docker push SEU_USUARIO/zendesk-dashboard:latest"
  echo ""
  exit 1
fi

echo "  ✅ Docker encontrado em: $DOCKER"

# ── CONFIGURAÇÃO ─────────────────────────────────────────────
DOCKER_USER="${1}"

if [ -z "$DOCKER_USER" ]; then
  echo ""
  printf "  Digite seu usuário do Docker Hub: "
  read DOCKER_USER
fi

IMAGE_NAME="zendesk-dashboard"
TAG="latest"
DATE_TAG=$(date +%Y%m%d)
FULL_IMAGE="$DOCKER_USER/$IMAGE_NAME:$TAG"

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║   Zendesk Dashboard — Docker Push    ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
echo "  📦 Imagem: $FULL_IMAGE"
echo ""

# ── LOGIN ─────────────────────────────────────────────────────
echo "  🔐 Fazendo login no Docker Hub..."
"$DOCKER" login
echo ""

# ── BUILD ─────────────────────────────────────────────────────
echo "  🔨 Buildando imagem (linux/amd64)..."
"$DOCKER" build \
  --no-cache \
  --platform linux/amd64 \
  -t "$FULL_IMAGE" \
  -t "$DOCKER_USER/$IMAGE_NAME:$DATE_TAG" \
  .
echo ""

# ── PUSH ──────────────────────────────────────────────────────
echo "  🚀 Enviando para o Docker Hub..."
"$DOCKER" push "$FULL_IMAGE"
"$DOCKER" push "$DOCKER_USER/$IMAGE_NAME:$DATE_TAG"
echo ""

echo "  ✅ Pronto! Imagem disponível em:"
echo "     https://hub.docker.com/r/$DOCKER_USER/$IMAGE_NAME"
echo ""
echo "  ─────────────────────────────────────────────────────"
echo "  Cole no Portainer > Stacks > Add Stack:"
echo ""
echo "  services:"
echo "    zendesk-dashboard:"
echo "      image: $FULL_IMAGE"
echo "      container_name: zendesk-dashboard"
echo "      ports:"
echo "        - \"3737:3737\""
echo "      restart: unless-stopped"
echo "  ─────────────────────────────────────────────────────"
echo ""
