# Usa a imagem oficial do n8n (baseada em Alpine)
FROM n8nio/n8n

LABEL maintainer="geovane@alunos.utfpr.edu.br"
LABEL description="N8N com Playwright usando Chromium do sistema"

USER root

# Instala dependências essenciais e Chromium do sistema Alpine
RUN apk add --no-cache \
    git \
    curl \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    libstdc++ \
    && rm -rf /var/cache/apk/*

# Instala Playwright
RUN npm install -g playwright

# NÃO instala browsers do Playwright, usa o do sistema
# Define variável para usar Chromium do sistema
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser

USER node

EXPOSE 5678

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

CMD ["n8n"]