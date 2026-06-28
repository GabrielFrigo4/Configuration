# 💻 Software (Dotfiles)

Esta pasta é o repositório tradicional de "dotfiles" para a interface gráfica e o host. Ela contém as configurações dos aplicativos de usuário instalados pelo bootstrap.

## O Que Encontrar Aqui

- **`editors/`**: Configurações (ex: `settings.json`, perfis) e scripts de setup para Neovim, Emacs, Helix, VS Code.
- **`terminals/`**: Perfis gráficos para terminais (Konsole do KDE, Windows Terminal, etc). Lembre-se que o Konsole precisará de caminhos específicos para os shells dependendo do SO hospedeiro (ex: `/usr/local/bin/zsh` no FreeBSD).
- **`tools/`**: Configurações globais para as poucas ferramentas "puras" que rodam no host (linters básicos de editor, formatadores como `.clang-format` ou `prettier`).
- **[external.md](external.md)**: Catálogo de softwares externos, utilitários manuais e aplicativos da Microsoft Store.

## O Que NÃO Encontrar Aqui

- **Comportamento Dinâmico de Shell**: Zshrc, Bashrc ou aliases. Vá para o repositório **Shell**.
- **Segredos e Credenciais**: Chaves SSH e Tokens. Vá para o repositório **Vault**.
- **Dependências de Desenvolvimento Node/Python/Ruby**: Eles não devem estar no host (e portanto não precisam de dotfiles complexos aqui). Devem ser configurados dentro dos seus Jails/Containers.
