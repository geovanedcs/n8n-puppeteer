# Começamos com a imagem oficial do n8n como base
# Atualização forçada em 24/09/2025 para rebuild da imagem novamente
FROM n8nio/n8n

# Metadata
LABEL maintainer="geovane@alunos.utfpr.edu.br"
LABEL description="N8N com Puppeteer e dependências para automação web"

# Trocamos para o usuário root para poder instalar pacotes
USER root


# Instala dependências do sistema e Python para Playwright
RUN apk add --no-cache \
    udev \
    ttf-freefont \
    chromium \
    curl \
    python3 \
    py3-pip \
    && rm -rf /var/cache/apk/*

# Instala Playwright para Python e suas dependências
RUN pip3 install --no-cache-dir --break-system-packages playwright && playwright install --with-deps

# Configurações do Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    NODE_PATH=/usr/local/lib/node_modules

# Instala pacotes npm do Puppeteer em uma única camada
RUN npm install -g --unsafe-perm --no-audit --no-fund \
    puppeteer \
    puppeteer-extra \
    puppeteer-extra-plugin-stealth \
    puppeteer-extra-plugin-user-preferences \
    puppeteer-extra-plugin-user-data-dir \
    && npm cache clean --force

# Retorna para o usuário padrão 'node' para a execução normal do n8n
USER node

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1