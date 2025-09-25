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


# Instala Puppeteer e plugins stealth, user-preferences, user-data-dir
RUN npm install -g puppeteer puppeteer-extra puppeteer-extra-plugin-stealth puppeteer-extra-plugin-user-preferences puppeteer-extra-plugin-user-data-dir

# Define variável para usar Chromium do sistema no Puppeteer
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

USER node

EXPOSE 5678

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

CMD ["n8n"]