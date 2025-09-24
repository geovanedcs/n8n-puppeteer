# N8N with Puppeteer - Auto Build

Imagem Docker personalizada do N8N com Puppeteer e dependências para automação web.

## Características

- Baseado na imagem oficial do N8N
- Puppeteer e plugins instalados
- Build automático via GitHub Actions
- Atualização automática via Watchtower

## Uso

````yaml
# n8n-puppeteer

## GitFlow

- Branch principal: `main`
- Branch de desenvolvimento: `develop`
- Novos recursos: `feature/nome-da-feature`
- Correções urgentes: `hotfix/nome-do-hotfix`

## Deploy automático

O deploy é feito automaticamente via GitHub Actions para o servidor em `/home/ubuntu/n8n`.

### Como configurar o servidor

1. Clone este repositório em `/home/ubuntu/n8n`:
  ```bash
  git clone https://github.com/geovanedcs/n8n-puppeteer.git /home/ubuntu/n8n
````

2. Gere uma chave SSH e adicione a pública nas _Deploy Keys_ do GitHub.
3. Adicione as secrets no repositório:

- `SERVER_HOST`: IP ou domínio do servidor
- `SERVER_USER`: usuário SSH (ex: ubuntu)
- `SERVER_SSH_KEY`: chave privada SSH

### Como funciona o deploy

A cada push na branch `main`, o workflow conecta no servidor, faz `git pull` e executa `docker-compose up -d`.

---

## Docker

- Certifique-se de que `docker-compose.yml` e `Dockerfile` estejam corretos para produção.

---

## Estrutura de branches

- `main`: produção
- `develop`: homologação/desenvolvimento
- `feature/*`: novas funcionalidades
- `hotfix/*`: correções urgentes

---

## Como contribuir

1. Crie uma branch a partir de `develop`:

```bash
git checkout develop
git checkout -b feature/nome-da-feature
```

2. Faça commits e abra um Pull Request para `develop`.
