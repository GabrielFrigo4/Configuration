# 🔒 The Vault

O **[Vault](https://github.com/GabrielFrigo4/Vault)** é o repositório privado do ecossistema, responsável pelo gerenciamento de credenciais, chaves SSH, tokens de API e variáveis de ambiente sensíveis.

Sempre que a infraestrutura, um script de configuração do Git ou o acesso a um servidor depender de informações restritas, os dados serão extraídos localmente do Vault.

## 📂 Localização de Instalação

O Vault deve ser clonado e posicionado no seguinte caminho seguro:

```bash
~/.vault
```

**Permissões:** O diretório do Vault deve possuir restrições severas de leitura (geralmente `chmod 700 ~/.vault`), e suas chaves não devem estar expostas a outros usuários do sistema operacional.

## Variáveis (config.env)

Um dos arquivos principais mantidos no repositório é o `config.env` (localizado em `~/.vault/config.env`). Vários scripts no repositório de `Configuration` fazem o _source_ deste arquivo para recuperar variáveis automaticamente, como por exemplo:

- `$GIT_AUTHOR_NAME`
- `$GIT_AUTHOR_EMAIL`

Se você estiver rodando scripts de setup em uma máquina limpa, garanta que o Vault esteja adequadamente populado no seu sistema **antes** de tentar configurar credenciais globais de Git ou SSH.
