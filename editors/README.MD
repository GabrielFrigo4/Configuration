# Unified Editor Configurations
 Este repositório contém configurações otimizadas e modulares para **Vim, Neovim, Helix, Emacs e Zed**.

 O objetivo é manter uma experiência de edição consistente (keybindings, indentação e comportamento) através de diferentes editores, permitindo alternar entre eles sem fricção cognitiva.

## 🧠 A Filosofia "Tiered Setup" (Níveis)
 A configuração segue uma estrutura hierárquica dividida em 3 níveis. Cada nível herda ou expande o anterior, permitindo escalar de um servidor legado até uma IDE moderna.

 | Nível | Nome do Arquivo | Cenário de Uso | Foco Principal |
 | :--- | :--- | :--- | :--- |
 | **1** | `minimal` | **Rescue / Server** | Compatibilidade máxima (SSH/TTY). Sem mouse, boot instantâneo (<0.1s), visual limpo. |
 | **2** | `standard` | **Daily Driver** | Edição confortável. Cores reais (`termguicolors`), mouse ativado, clipboard do sistema, fonte Nerd Font. |
 | **3** | `ultimate` | **Pro / IDE** | Desenvolvimento pesado. LSP (Autocompletar), Treesitter (Highlight), Project Management e regras de linguagem. |

---

## 🐚 Shell Integration (Aliases)
 Para utilizar o potencial máximo deste repositório, recomenda-se adicionar estes aliases ao seu `.bashrc` ou `.zshrc`. Eles permitem alternar entre níveis de complexidade instantaneamente via variáveis de ambiente ou flags.

 ```bash
 # --- VIM (Legacy & Rescue) ---
 alias vi='command vim'  # Usa o .vimrc minimal (Rescue)
 alias vim='command vim -u ~/vimfiles/vimrc/ultimate.vim' # IDE Mode

 # --- NEOVIM (Lua Moderno) ---
 # Requer lógica de leitura de ENV no init.lua
 alias nmin='NVIM_PROFILE=minimal nvim'
 alias nstd='NVIM_PROFILE=standard nvim'
 alias n='NVIM_PROFILE=ultimate nvim'

 # --- EMACS (Native 30+) ---
 # -q evita carregar configs padrão extras, -l carrega nosso arquivo
 alias emacs-min='emacs -q -l ~/.emacs.d/minimal.el'
 alias emacs='emacs -q -l ~/.emacs.d/ultimate.el'

 # --- HELIX (Rust) ---
 alias hx-min='helix -c ~/.config/helix/minimal.toml'
 alias hx='helix -c ~/.config/helix/ultimate.toml'
 ```

---

## 📏 Regras Globais de Indentação
 Todos os editores estão configurados para respeitar rigorosamente estas regras de estilo:

 * **Hard Tabs (4 de largura):** Obrigatório para **Go**, **Assembly** e **Makefiles**.
 * **2 Espaços (Soft):** Web stack (**JS, TS, HTML, CSS, JSON**) e **Lua**.
 * **4 Espaços (Soft):** Linguagens de sistema e scripts (**C, C++, Rust, Python, Java**).

---

## 🛠️ Editores Suportados

### 1. [Neovim (Lua)](neovim/README.MD)
 Configuração moderna escrita 100% em Lua.

 * **Destaques:** Carregamento modular via `NVIM_PROFILE`, cursor nativo (`guicursor`), navegação lateral (`whichwrap`).
 * **Caminho:** `~/.config/nvim/`

### 2. [Vim (Vimscript)](vim/README.MD)
 Configuração clássica e robusta.

 * **Destaques:** Suporte a "One-Liners" (versões compactadas para servidores), compatibilidade total com vi legado.
 * **Caminho:** `~/.vimrc`

### 3. [Emacs (Native 30+)](emacs/README.MD)
 Configuração "Bleeding Edge" focada no **Emacs 30**.

 * **Destaques:** Zero packages externos pesados. Usa **Treesit** (parser nativo) e **Eglot** (LSP nativo).
 * **Visual:** Integração nativa com tema *Wombat* e *JetBrainsMono NF*.
 * **Caminho:** `~/.emacs.d/`

### 4. [Helix](helix/README.MD)
 Configuração modular via arquivos TOML separados.

 * **Destaques:** Mapeamentos "Vim-Like" no nível Ultimate (Space leader) e LSP Zero-Config (Rust/Go/Python).
 * **Caminho:** `~/.config/helix/`

### 5. [Zed](zed/README.MD)
 Configuração focada na experiência nativa ("Zed Style").

 * **Destaques:** **Sem Vim Mode** (uso de atalhos nativos CUA/macOS), predições de IA ativadas, LSP com caminhos absolutos.
 * **Caminho:** `~/.config/zed/`

---

## 📂 Estrutura do Repositório
 ```text
 .
 ├── emacs/
 │   ├── minimal.el
 │   ├── standard.el
 │   └── ultimate.el
 ├── helix/
 │   ├── languages.toml
 │   ├── minimal.toml
 │   ├── standard.toml
 │   └── ultimate.toml
 ├── neovim/
 │   ├── minimal.lua
 │   ├── standard.lua
 │   └── ultimate.lua
 ├── vim/
 │   ├── minimal.vim
 │   ├── standard.vim
 │   └── ultimate.vim
 └── zed/
     ├── unix/settings.json
     └── win/settings.json
 ```

## ⚙️ Pré-Requisitos (Ultimate/Standard)
 Para a experiência completa nos níveis 2 e 3, recomenda-se:

 1. **Fonte:** [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts) (Essencial para Emacs e Neovim).
 2. **LSP Servers (Language Servers):**
 * `clangd` (C/C++)
 * `gopls` (Go)
 * `pyright` (Python)
 * `rust-analyzer` (Rust)
 3. **Ferramentas de Busca:** `ripgrep` (rg) e `fd` (usados pelo Telescope no Nvim e Fido no Emacs).

---

## 🚀 Instalação Rápida
 Consulte o `README` dentro da pasta de cada editor para instruções específicas de link simbólico ou cópia.
