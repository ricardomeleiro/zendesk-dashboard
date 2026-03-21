#!/bin/bash
echo ""
echo " =========================================="
echo "  Zendesk Dashboard - Proxy Local"
echo " =========================================="
echo ""

if ! command -v node &> /dev/null; then
  echo " ERRO: Node.js não encontrado!"
  echo " Baixe em: https://nodejs.org"
  exit 1
fi

echo " Node.js OK: $(node --version)"
echo ""
echo " Instalando dependências (primeira vez)..."
npm install
echo ""
echo " Iniciando proxy..."
echo " Acesse: http://localhost:3737"
echo ""
node server.js
