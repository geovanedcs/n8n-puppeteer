# Usa imagem oficial do n8n como base
FROM n8nio/n8n

LABEL maintainer="geovane@alunos.utfpr.edu.br"
LABEL description="N8N com Puppeteer e Playwright para automação web"

USER root

# Instala dependências do sistema completas para Alpine
RUN apk add --no-cache \
    python3 \
    python3-dev \
    py3-pip \
    py3-setuptools \
    py3-wheel \
    build-base \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    font-noto \
    fontconfig \
    git \
    curl \
    chromium \
    chromium-chromedriver \
    firefox

# Atualiza pip para versão mais recente
RUN python3 -m pip install --upgrade pip

# Instala Puppeteer e plugins
RUN npm install -g puppeteer puppeteer-extra puppeteer-extra-plugin-stealth puppeteer-extra-plugin-user-preferences puppeteer-extra-plugin-user-data-dir

# Instala Playwright para Python e suas dependências em um venv
RUN python3 -m venv /venv \
    && . /venv/bin/activate \
    && pip install --upgrade pip setuptools wheel \
    && pip install --no-cache-dir playwright \
    && /venv/bin/python -m playwright install --with-deps

# Define variáveis de ambiente para Playwright
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

# Torna o venv disponível para o usuário node
RUN chown -R node:node /venv

USER node

EXPOSE 5678

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

CMD ["n8n"]