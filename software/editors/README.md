# Editors

Scripts de instalação e configurações dos editores de texto e código.

## Estrutura

Cada editor possui dois modos de instalação:

- **`install-custom`** — Clona o repositório pessoal de configuração (minimalista, personalizado).
- **`install-framework`** — Instala um framework completo (Doom Emacs, LazyVim, SpaceVim) com plugins e temas.

| Editor          | Custom          | Framework               | Repositório                                           |
| :-------------- | :-------------- | :---------------------- | :---------------------------------------------------- |
| **Emacs**       | `.sh` `.cmd`    | Doom Emacs `.sh` `.cmd` | [.emacs.d](https://github.com/GabrielFrigo4/.emacs.d) |
| **Neovim**      | `.sh` `.cmd`    | LazyVim `.sh` `.cmd`    | [nvim](https://github.com/GabrielFrigo4/nvim)         |
| **Vim**         | `.sh` `.cmd`    | SpaceVim `.sh` `.cmd`   | [vimfiles](https://github.com/GabrielFrigo4/vimfiles) |
| **Helix**       | `.sh` `.cmd`    | —                       | [helix](https://github.com/GabrielFrigo4/helix)       |
| **Zed**         | `settings.json` | —                       | —                                                     |
| **VS Code**     | `settings.json` | —                       | —                                                     |
| **VS Codium**   | `settings.json` | —                       | —                                                     |
| **Antigravity** | `settings.json` | —                       | —                                                     |

## Configs de Editores GUI

Os editores GUI (Zed, VS Code, VSCodium, Antigravity) possuem um `settings.json` que deve ser copiado para o diretório de configuração do editor:

| Editor          | Destino (Linux)                            | Destino (Windows)                          |
| :-------------- | :----------------------------------------- | :----------------------------------------- |
| **Zed**         | `~/.config/zed/settings.json`              | `%APPDATA%\Zed\settings.json`              |
| **VS Code**     | `~/.config/Code/User/settings.json`        | `%APPDATA%\Code\User\settings.json`        |
| **VS Codium**   | `~/.config/VSCodium/User/settings.json`    | `%APPDATA%\VSCodium\User\settings.json`    |
| **Antigravity** | `~/.config/Antigravity/User/settings.json` | `%APPDATA%\Antigravity\User\settings.json` |

## Configs Inline do Bootstrap

Alguns editores recebem configurações inline durante o bootstrap do sistema. Essas configs não estão nesta pasta pois são geradas no momento da instalação:

### Emacs — Config standalone (MSYS2)

No MSYS2, ao invés de clonar o repositório `.emacs.d`, o bootstrap cria um arquivo `.emacs` standalone com a configuração completa (Treesit, Eglot, Wombat theme, JetBrainsMono NF). Veja o heredoc em `bootstrap/msys2/setup.sh`.

### Vim — Entry point (`.vimrc`)

Os scripts `install-custom` já criam o `.vimrc` automaticamente. Para referência, o conteúdo do entry point é:

```vim
set rtp+=~/vimfiles
source ~/vimfiles/vimrc
```

O bootstrap também cria um `.vimrc` standalone (one-liner compactado) para ambientes sem o repositório git:

```vim
syn on|filetype plugin indent on
se nocp nu rnu ls=2 sc enc=utf-8 bs=2 ww+=<,>,h,l,[,] hi=256 nobk noswf hls is ai si
se tgc cul nowrap mouse=a mousemodel=popup ts=4 sts=4 sw=4 et
se wmnu wim=longest:full,full so=8 scl=yes sb spr ic scs
try|se cb^=unnamed,unnamedplus|colo habamax|catch|endtry
au FileType javascript,typescript,javascriptreact,typescriptreact,lua,html,css,json,yaml setl ts=2 sw=2 sts=2 et
au FileType python,org,go,asm,nasm,masm,fasm setl ts=4 sw=4 sts=4 noet
au FileType c,cpp,rust,cs,java,zig,arduino setl ts=4 sw=4 sts=4 et
let mapleader="\<Space>"|nn <space> <nop>|nn <leader>w :w<cr>|nn <leader>q :q<cr>
nn <expr> <BS> col('.')==1?'kgJ':'X'
let &t_SI="\<Esc>[5 q"|let &t_SR="\<Esc>[3 q"|let &t_EI="\<Esc>[1 q"
```
