# Usa a imagem oficial do n8n (baseada em Alpine)
FROM n8nio/n8n

LABEL maintainer="geovane@alunos.utfpr.edu.br"
LABEL description="N8N com Playwright para automação web"

USER root

# Instala apenas dependências essenciais
RUN apk add --no-cache \
    git \
    curl

# Instala Playwright
RUN npm install -g playwright

# Instala browser Chromium com dependências
RUN npx playwright install chromium --with-deps

# Instala dependências extras do sistema para Chromium no Alpine
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    && rm -rf /var/cache/apk/*

# Define variáveis de ambiente para Playwright
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser

USER node

EXPOSE 5678

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

CMD ["n8n"]