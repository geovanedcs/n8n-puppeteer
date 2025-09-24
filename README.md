# N8N with Puppeteer - Auto Build

Imagem Docker personalizada do N8N com Puppeteer e dependências para automação web.

## Características
- Baseado na imagem oficial do N8N
- Puppeteer e plugins instalados
- Build automático via GitHub Actions
- Atualização automática via Watchtower

## Uso
```yaml
services:
  n8n:
    image: geovanedcs/n8n-puppeteer:latest
    # ... suas configurações