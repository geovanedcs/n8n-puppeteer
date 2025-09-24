# Usa imagem oficial do n8n como base
FROM n8nio/n8n

LABEL maintainer="geovane@alunos.utfpr.edu.br"
LABEL description="N8N com Puppeteer e Playwright para automação web"

USER root

# Instala dependências mínimas
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-setuptools \
    git \
    curl

# Instala Puppeteer
RUN npm install -g puppeteer

# Cria virtual environment
RUN python3 -m venv /opt/playwright-env

# Instala playwright no venv
RUN /opt/playwright-env/bin/pip install --upgrade pip && \
    /opt/playwright-env/bin/pip install playwright

# Instala apenas chromium (mais leve)
RUN /opt/playwright-env/bin/playwright install chromium

# Cria link simbólico para facilitar acesso
RUN ln -s /opt/playwright-env/bin/python /usr/local/bin/python-playwright && \
    ln -s /opt/playwright-env/bin/playwright /usr/local/bin/playwright

# Ajusta permissões
RUN chown -R node:node /opt/playwright-env

# Remove cache para reduzir tamanho
RUN rm -rf /var/cache/apk/* /tmp/*

USER node

EXPOSE 5678

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

CMD ["n8n"]