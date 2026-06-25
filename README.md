# Configuration

Repositório central de configurações de software, ferramentas de desenvolvimento e scripts de bootstrap do sistema.

## 📂 Project Structure

O repositório é organizado de forma modular, seguindo a filosofia de "uma coisa, um lugar". A configuração do sistema está separada da configuração dos softwares, o que simplifica a manutenção e adaptação para diferentes sistemas operacionais.

- **`bootstrap/`** — Scripts monolíticos e modulares de instalação e bootstrap de sistemas operacionais limpos (Arch Linux, Debian, Windows, MSYS2). Automatizam a instalação de pacotes essenciais, setup inicial de rede, virtualização, etc.
- **`software/`** — Configurações específicas e scripts de setup dos softwares utilizados pelo usuário. Todos os arquivos dotfiles (`.clang-format`, `settings.json`, profiles) vivem aqui.
    - **`editors/`** — Instalação e profiles do Emacs, NeoVim, Vim, Helix, Zed, VS Code e derivados.
    - **`terminals/`** — Perfis e configurações de ambientes de terminal (Nushell, PowerShell, Konsole, CMD).
    - **`tools/`** — Configuração global de formatadores, linters (Prettier, StyLua, Clangd) e utilitários de linha de comando.
- **`scripts/`** — Scripts utilitários de uso diário (conversão de mídia, configuração do git usando Vault, customizações do registro do Windows).
- **`docs/`** — Documentação detalhada sobre ambientes (KDE Wayland/X11, Polkit), tabelas de referências, downloads manuais, guias e dicas gerais do ecossistema.
