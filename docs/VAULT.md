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

Um dos arquivos principais mantidos no repositório é o `config.env` (localizado em `~/.vault/config.env`). Ele contém variáveis de ambiente como:

- `$GIT_AUTHOR_NAME`
- `$GIT_AUTHOR_EMAIL`
- `$FRIGO_SERVER_KEY`, `$FRIGO_SERVER_IP`
- `$ORBS_SERVER_KEY`, `$ORBS_SERVER_IP`

### Carregamento Automático

O Vault é carregado automaticamente pelo repositório **Shell**, que por sua vez é sourced pelos arquivos de RC do shell (`.zshrc`, `.bashrc`, `.shrc`). Portanto, **não é necessário** fazer `source ~/.vault/config.env` manualmente nos scripts de bootstrap — basta consumir as variáveis diretamente, assumindo que o ecossistema já as proveu globalmente.

Se você estiver rodando scripts de setup em uma máquina limpa, garanta que o Vault e o Shell estejam adequadamente populados no seu sistema **antes** de tentar configurar credenciais globais de Git ou SSH.

### Exceção: Windows (Nushell/PowerShell)

No Windows, o Nushell (`config.nu`) e o PowerShell fazem `source` explícito do Vault (`~/.vault/vault.nu`). Esse é um comportamento intencional e específico da plataforma — não deve ser removido.
