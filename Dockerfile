FROM node:20-alpine

WORKDIR /app

# Copia dependências primeiro (cache layer)
COPY package*.json ./
RUN npm install --omit=dev

# Copia o restante da aplicação
COPY server.js ./
COPY public/ ./public/

EXPOSE 3737

CMD ["node", "server.js"]
