# 🐚 Shell Ecosystem

O repositório **[Shell](https://github.com/GabrielFrigo4/Shell)** é uma parte fundamental do ecossistema de configuração. Ele contém scripts utilitários, aliases globais, funções e lógicas de terminal de uso diário que complementam o repositório de `Configuration`.

Diferente das configurações estáticas e dotfiles (que ficam neste repositório de `Configuration`), o `Shell` é focado em comportamento ativo do terminal.

## 📂 Localização de Instalação

O repositório Shell é clonado em caminhos diferentes de acordo com a plataforma em uso. Seu terminal (Bash, Zsh, Nushell, PowerShell, CMD) deve ser configurado para consumir e carregar (`source`) os arquivos do Shell nestas localidades:

| Plataforma                             | Caminho Padrão           |
| :------------------------------------- | :----------------------- |
| **UNIX (Linux, FreeBSD, macOS, WSL2)** | `/usr/local/share/shell` |
| **Windows (MSYS2)**                    | `~/.shell`               |

Muitos scripts dentro deste repositório de `Configuration` podem fazer referência indireta a funções e aliases estabelecidos pelo repositório `Shell`. Certifique-se de que o repositório esteja corretamente baixado no caminho apropriado.
