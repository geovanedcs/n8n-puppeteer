
# Usa imagem oficial do n8n como base
FROM n8nio/n8n

LABEL maintainer="geovane@alunos.utfpr.edu.br"
LABEL description="N8N com Puppeteer e Playwright para automação web"

USER root

# Instala dependências do sistema e Python (Alpine)
RUN apk add --no-cache \
    python3 \
    py3-pip \
    fonts-freefont-ttf \
    git \
    curl

# Instala Puppeteer e plugins
RUN npm install -g puppeteer puppeteer-extra puppeteer-extra-plugin-stealth puppeteer-extra-plugin-user-preferences puppeteer-extra-plugin-user-data-dir

# Instala Playwright para Python e suas dependências
RUN pip3 install --no-cache-dir playwright && python3 -m playwright install --with-deps

USER node

EXPOSE 5678

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

CMD ["n8n"]