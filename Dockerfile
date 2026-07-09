# Estágio 1: Construir a aplicação React (Frontend)
FROM node:20 AS builder

WORKDIR /app

# Copiar arquivos de dependências
COPY package*.json ./

# Instalar todas as dependências (incluindo devDependencies necessárias para o build)
RUN npm ci

# Copiar todo o código-fonte da aplicação
COPY . .

# Executar o build de produção do Vite (gera os arquivos estáticos na pasta /app/dist)
RUN npm run build

# Estágio 2: Imagem final para execução em produção (leve e segura)
FROM node:20-slim AS runner

WORKDIR /app

# Definir variável de ambiente de produção
ENV NODE_ENV=production

# Copiar arquivos de dependências
COPY package*.json ./

# Instalar apenas as dependências de produção para manter a imagem leve
RUN npm ci --only=production

# Copiar o servidor Express e os arquivos estáticos compilados do estágio anterior
COPY server.js ./
COPY --from=builder /app/dist ./dist

# O Google Cloud Run define e injeta a porta automaticamente na variável $PORT.
# Expomos a porta padrão (3000) por boas práticas.
EXPOSE 3000

# Comando para iniciar o servidor Express em produção
CMD ["node", "server.js"]
