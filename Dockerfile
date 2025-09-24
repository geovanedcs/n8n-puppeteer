# Usa imagem oficial do n8n como base
FROM n8nio/n8n

LABEL maintainer="geovane@alunos.utfpr.edu.br"
LABEL description="N8N com Puppeteer e Playwright para automação web"

USER root

# Instala apenas dependências essenciais para Alpine
RUN apk add --no-cache \
    python3 \
    python3-dev \
    py3-pip \
    build-base \
    gcc \
    musl-dev \
    libffi-dev \
    git \
    curl

# Instala Puppeteer e plugins
RUN npm install -g puppeteer puppeteer-extra puppeteer-extra-plugin-stealth puppeteer-extra-plugin-user-preferences puppeteer-extra-plugin-user-data-dir

# Cria venv e instala playwright em etapas separadas
RUN python3 -m venv /venv

# Atualiza pip dentro do venv (sem usar pip global)
RUN /venv/bin/pip install --upgrade pip

# Instala playwright
RUN /venv/bin/pip install playwright

# Instala apenas chromium para reduzir tamanho
RUN /venv/bin/python -m playwright install chromium

# Limpa cache e arquivos temporários para reduzir tamanho da imagem
RUN apk del python3-dev build-base gcc musl-dev libffi-dev \
    && rm -rf /var/cache/apk/* /tmp/* /root/.cache /root/.npm

# Define variáveis de ambiente
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Torna o venv disponível para o usuário node
RUN chown -R node:node /venv

# Cria script wrapper para facilitar uso do python com venv
RUN echo '#!/bin/sh\nexec /venv/bin/python "$@"' > /usr/local/bin/python-playwright \
    && chmod +x /usr/local/bin/python-playwright

USER node

EXPOSE 5678

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

CMD ["n8n"]