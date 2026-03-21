# 📊 Zendesk Dashboard — Painel TV

Painel em tempo real para TV/tela da equipe. Atualização automática a cada 10 minutos.

---

## 🐳 Rodar com Docker (recomendado)

### Pré-requisito
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado

### Opção A — Docker Compose (mais simples)

```bash
docker compose up -d
```

Acesse: **http://localhost:3737**

Para parar:
```bash
docker compose down
```

Para ver os logs:
```bash
docker compose logs -f
```

---

### Opção B — Docker puro

```bash
# Build da imagem
docker build -t zendesk-dashboard .

# Rodar o container
docker run -d \
  --name zendesk-dashboard \
  --restart unless-stopped \
  -p 3737:3737 \
  zendesk-dashboard
```

Acesse: **http://localhost:3737**

Para parar:
```bash
docker stop zendesk-dashboard && docker rm zendesk-dashboard
```

---

### Expor em outra porta (ex: porta 80)

```bash
docker run -d --name zendesk-dashboard --restart unless-stopped -p 80:3737 zendesk-dashboard
```

Ou no docker-compose.yml, altere:
```yaml
ports:
  - "80:3737"
```

---

## 🖥️ Rodar sem Docker (Node.js local)

```bash
npm install
node server.js
```

Windows: clique duas vezes em INICIAR.bat
Mac/Linux: chmod +x iniciar.sh && ./iniciar.sh

---

## 🔑 Como obter o Token de API do Zendesk

1. Acesse seu Zendesk como administrador
2. Vá em: Admin Center → Apps & Integrations → APIs → Zendesk API
3. Em Token Access, clique em Add API Token
4. Copie o token (aparece apenas uma vez!)

---

## 📊 Métricas do painel

- Resolvidos Hoje — tickets com status "solved" atualizados hoje
- Abertos Hoje — tickets criados hoje
- Em Andamento — tickets open + pending
- Semana Corrente — resolvidos desde segunda-feira
- Urgentes Abertos — tickets urgentes em aberto
- Ranking Agentes — quem mais resolveu hoje e na semana
- Gráfico Semanal — volume por dia da semana atual
- SLA — taxa de resolução e cumprimento de prazo

---

## 🔒 Segurança

O proxy roda localmente. As credenciais são passadas como headers entre o browser e o localhost — nada é salvo ou enviado a terceiros.

Para expor o painel na rede interna (TV da equipe em outro dispositivo), rode na máquina host e acesse pelo IP local: http://192.168.x.x:3737
