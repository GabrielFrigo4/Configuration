# Refatoração FreeBSD + Remoção de Dependências do Vault

Plano de execução completo para os itens 1 e 3 do [TODO.md](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/TODO.md), com a resolução do dilema **Modularização vs Manutenção vs Usabilidade** levantado pelo usuário.

## O Dilema: Modularização vs Manutenção vs Usabilidade

Antes de qualquer mudança nos scripts, precisamos resolver a tensão central:

| Força | Problema Atual |
|---|---|
| **Modularização** | Quebrar em 50 arquivos minúsculos é inviável para rodar num FreeBSD sem GUI (sem copiar/colar fácil) |
| **Manutenção** | Scripts monolíticos de ~770 linhas (FreeBSD desktop) com blocos inteiros duplicados entre SOs |
| **Usabilidade** | Num fresh install sem X11, o usuário precisa rodar **o mínimo possível** de comandos |

### Solução Proposta: "Poucos scripts, zero duplicação"

A ideia **não** é explodir em dezenas de micro-scripts. É manter **poucos scripts executáveis por perfil** (setup, fonts, gui), mas **extrair a lógica compartilhada** para o `bootstrap/common/` como funções sourced ou blocos copiáveis.

**Estrutura proposta:**

```
bootstrap/
├── common/                         # Lógica compartilhada (UNIX-wide)
│   ├── git.sh                      # ✅ Já existe
│   ├── fonts.sh                    # [NEW] Instalação de Nerd Fonts
│   ├── editors.sh                  # [NEW] Setup de Doom Emacs, LazyVim, Micro, Helix, Vim
│   └── tools.sh                    # [NEW] Configs estáticas (clangd, clang-format, prettier, stylua)
├── freebsd/
│   ├── desktop/
│   │   ├── setup.sh                # [REFACTOR] Script principal enxuto (sistema + pacotes host)
│   │   ├── fonts.sh                # [NEW] Wrapper: source common/fonts.sh + fc-cache FreeBSD
│   │   ├── gui.sh                  # [NEW] LY, SDDM, Xorg, Konsole profiles FreeBSD
│   │   ├── config/...              # ✅ Já existe e está bem modularizado
│   │   ├── bastille/...            # ✅ Já existe
│   │   └── docs/...                # ✅ Já existe
│   └── server/
│       ├── setup.sh                # [REFACTOR] Enxugar, remover dev tools
│       └── connect/...             # ✅ Já existe
├── linux/
│   └── desktop/
│       ├── arch/setup.sh           # [REFACTOR] Usar common/ para editors/fonts/tools
│       └── debian/setup.sh         # [REFACTOR] Usar common/ para editors/fonts/tools
└── ...
```

> [!IMPORTANT]
> **Princípio chave:** Um FreeBSD fresh install sem GUI exige no máximo **2–3 comandos** para ficar pronto:
> 1. `sh setup.sh` (como root, depois como user) — instala tudo que é essencial
> 2. `sh fonts.sh` — instala fontes (opcional, só se tiver GUI)
> 3. `sh gui.sh` — configura display manager + Konsole (opcional, só desktop)
>
> O `common/` é consumido via `source` internamente pelos scripts. O usuário **nunca** precisa rodar os scripts de `common/` manualmente.

---

## User Review Required

> [!IMPORTANT]
> **Decisão 1 — Manter `Shell.profile` do Konsole no FreeBSD?**
> O FreeBSD desktop cria um `Shell.profile` com `SHELL_INIT=1,SHELL_TARGET=/bin/sh` e `Command=/bin/sh`. Esse profile não existe no Linux (`software/terminals/konsole/`). Ele deve ser mantido como perfil exclusivo do FreeBSD? Ou é obsoleto agora que o Shell repo gerencia tudo?

> [!IMPORTANT]
> **Decisão 2 — Nushell e PowerShell config.nu**
> O arquivo [config.nu](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/software/terminals/nushell/config.nu) faz `source ~/.vault/vault.nu` (linha 9). Isso é um dotfile do Windows/MSYS2, então ele escapa do escopo FreeBSD. Devo limpar essa referência ao Vault neste plano, ou fica para outro momento?

> [!IMPORTANT]
> **Decisão 3 — Profundidade da limpeza nos scripts Linux**
> Os scripts `arch/setup.sh` e `debian/setup.sh` também têm duplicação massiva de fonts, editors, tools, e `source vault`. Devo incluir a refatoração deles para usar `common/` neste mesmo plano, ou focamos só no FreeBSD agora e os Linux ficam para uma segunda rodada?

> [!WARNING]
> **Decisão 4 — Pacotes de desenvolvimento no FreeBSD host**
> O [setup.sh desktop](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/desktop/setup.sh) instala **diretamente no host** (linhas 609–644): gcc, llvm, rust, zig, go, nasm, fasm, deno, nodejs, npm, python, lua (5 versões!), luajit. Além disso, instala LSP servers (gopls, stylua, prettier, cargo install asm-lsp). Isso viola frontalmente a filosofia Clean Host. **Minha proposta é remover tudo isso.** O FreeBSD server faz o mesmo (linhas 340–360). Confirma a remoção total?

> [!WARNING]
> **Decisão 5 — Server scripts `frigo-server` e `orbs-server`**
> Os wrappers de SSH dos servidores reais (`/usr/local/bin/frigo-server` e `/usr/local/bin/orbs-server`) fazem `source ~/.vault/servers/servers.env` internamente. Como o Vault agora é carregado globalmente, esses scripts podem simplesmente consumir `$FRIGO_SERVER_KEY`, `$FRIGO_SERVER_IP`, etc. diretamente. Porém, esses wrappers são gerados por heredoc durante o bootstrap — ou seja, é um script estático instalado no sistema. Se o Vault é carregado pelo shell interativo (via `.zshrc`/`.bashrc`), o wrapper de SSH pode **não ter** as variáveis disponíveis quando chamado via cron ou por outro mecanismo não-interativo. **Preciso saber:** O Vault é carregado globalmente via `/etc/profile.d/`, via `~/.profile`, ou via shell RC files (`.zshrc`)?

---

## Open Questions

> [!IMPORTANT]
> **Q1 — Mecanismo de carregamento global do Vault:**
> Como exatamente o Vault é injetado no ambiente? Se é via `.zshrc`/`.bashrc` (Shell repo), os heredocs de server scripts (`frigo-server`, `orbs-server`) ainda precisariam do `source` explícito. Se é via `/etc/profile.d/` ou `~/.profile`, aí sim podemos removê-lo com segurança de everywhere.

> [!IMPORTANT]
> **Q2 — Scripts legados na raiz do bootstrap:**
> Os scripts [arch-linux.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/arch-linux.sh) (1133 linhas) e [ubuntu.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/ubuntu.sh) (46614 bytes!) na raiz de `bootstrap/` são cópias legadas dos que já existem em `linux/desktop/arch/setup.sh` e `linux/desktop/debian/setup.sh`? Podem ser deletados?

---

## Proposed Changes

As mudanças estão organizadas em 5 etapas lógicas e sequenciais.

---

### Etapa 1 — Criar `bootstrap/common/` (Eliminação de Duplicação)

O `common/` é a peça central para resolver o dilema de duplicação. Cada arquivo aqui é **sourced** pelos scripts de cada SO, nunca executado diretamente pelo usuário.

#### [NEW] [fonts.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/common/fonts.sh)

Extrair **todo** o bloco de instalação de Nerd Fonts que está duplicado identicamente em:
- [freebsd/desktop/setup.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/desktop/setup.sh) (linhas 178–256)
- [linux/desktop/arch/setup.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/linux/desktop/arch/setup.sh) (linhas 329–406)
- [freebsd/server/setup.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/server/setup.sh) (não tem fonts — correto, server não precisa)

Conteúdo: instalação de fontconfig, criação de `~/.local/share/fonts`, download de RobotoMono, JetBrainsMono, MesloLGS, JetBrains Mono (install_manual.sh), NerdFontsSymbolsOnly e `fc-cache`.

> [!NOTE]
> O `fc-cache` difere entre FreeBSD (`fc-cache -fv`) e Linux (`fc-cache -f`). O script `common/fonts.sh` usará `fc-cache -f` (funciona em ambos). O `-v` (verbose) é cosmético.

#### [NEW] [editors.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/common/editors.sh)

Extrair setup de editores que está duplicado entre FreeBSD desktop, FreeBSD server, e Linux:
- Clone dos repos Git (`.emacs.d`, `nvim`, `vimfiles`, `helix`) + git pull
- Setup Doom Emacs (clone, install, packages.el, init.el sed, config.el)
- Setup LazyVim (clone starter, options.lua com cursor piscante)
- Setup Micro (dracula theme, settings.json)

Parâmetros condicionais:
- FreeBSD desktop: inclui Emacs GUI + NeoVim + Vim + Helix + Micro
- FreeBSD server: **sem** Emacs GUI, NeoVim + Vim + Helix + Micro
- O setup do Doom Emacs `config.el` no desktop inclui a config de `doom-font`, no server não

#### [NEW] [tools.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/common/tools.sh)

Extrair criação de dotfiles de ferramentas que estão hardcoded via heredoc no FreeBSD desktop (linhas 660–744) e são **idênticos** aos que já existem em `software/tools/`:
- `~/.config/clangd/config.yaml` → cópia de [clangd.yaml](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/software/tools/clangd.yaml)
- `~/.clang-format` → cópia de [.clang-format](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/software/tools/.clang-format)
- `~/.prettierrc` → cópia de [.prettierrc](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/software/tools/.prettierrc)
- `~/.stylua.toml` → cópia de [.stylua.toml](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/software/tools/.stylua.toml)

**Em vez de heredocs**, o script fará `cp` dos arquivos já versionados em `software/tools/`. Isso elimina a duplicação e garante single source of truth.

> [!TIP]
> Isso exige que o repositório Configuration esteja clonado localmente (o que já é premissa do bootstrap). O script usará um caminho relativo ao repo ou uma variável `$CONFIG_REPO` para localizar os dotfiles.

#### [MODIFY] [git.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/common/git.sh)

O `git.sh` já existe e já usa `$GIT_AUTHOR_EMAIL` / `$GIT_AUTHOR_NAME` do Vault. Porém, **nenhum** dos scripts FreeBSD ou Linux o utiliza — todos duplicam o bloco de git config internamente. Ajustar para que os setup scripts passem a fazer `source` deste arquivo.

---

### Etapa 2 — Refatorar FreeBSD Desktop (`setup.sh` → `setup.sh` + `fonts.sh` + `gui.sh`)

#### [REFACTOR] [setup.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/desktop/setup.sh)

O setup.sh atual tem **769 linhas** e faz tudo: sistema, pacotes, fontes, Konsole, editores, linguagens, LSPs, softwares. Será reduzido drasticamente.

**O que permanece no `setup.sh`:**
- Setup System (Root): groups, pkg bootstrap, terminal font, sudo, doas (linhas 1–35) — limpar comentários `#`
- Setup Environment (Root): desktop-installer, coredump (linhas 37–49) — manter
- Setup Workspace: `mkdir -p ~/Workspace` (linhas 78–84)
- Setup Shell: instalar bash, zsh (linhas 87–93)
- Setup Wget/Curl (linhas 96–102)
- Setup Git: **substituir** bloco duplicado por `source common/git.sh` (linhas 104–124)
- Setup Ports (linhas 126–136) — remover `cd` desnecessário, usar `git -C`
- Setup Jails + Bastille + Linuxlator (linhas 138–161)
- Config Shell: `chsh` para sh (linhas 164–171)
- Installing Needed Tools: mandoc, zip/unzip/7-zip, gnupg/openssl/libressl (linhas 362–382) — **remover cmake, ninja, meson** (build systems = dev tools → container)
- Installing Rust Tools: eza, fd, bat, grex, ripgrep (linhas 384–395) — **remover `eza` duplicado** (linha 392)
- Installing System Fetch: fastfetch (linhas 396–405) — **remover neofetch** (abandonado), avaliar se ufetch/pfetch-rs/cpufetch são necessários
- Clipboard tools, w3m/lynx/elinks, netcat (linhas 410–427)
- Device tools: exfat, ntfs, ext2 (linhas 428–441) — manter (hardware host)
- TreeSitter: **remover** (pertence ao container ou ao editor que instala via plugin)
- Instalação de softwares GUI: firefox, chromium, libreoffice, krita, gimp, arianna (linhas 748–768) — manter
- Setup Real Server: **refatorar** heredocs para não fazer `source vault` (linhas 334–354)

**O que é REMOVIDO do `setup.sh`:**
- ❌ Toda a seção "Installing Languages" (linhas 609–644): gcc, llvm, rust, zig, go, nasm, fasm, deno, nodejs, npm, python, lua — tudo deve ir para Jails/Containers
- ❌ Toda a seção "Installing LSP Servers" (linhas 647–744): gopls, stylua, prettier, asm-lsp, clangd config, clang-format, prettierrc, stylua.toml — LSPs vivem no container ou são instalados pelo editor
- ❌ Seção "Config Shell" dos `.*shrc` — obsoleto (gerenciado pelo repo Shell)
- ❌ Seção "Installing Editor" / "Installing Git Config" / "Updating Git Config" / "Setup Emacs" / "Setup NeoVim" / "Setup Micro" (linhas 454–606) → movidos para `source common/editors.sh`
- ❌ Seção "Installing System Fonts" inteira (linhas 174–256) → movida para `fonts.sh`
- ❌ Seção "Setup Konsole Profiles" (linhas 259–331) → movida para `gui.sh`
- ❌ Comentários `#` literais desnecessários (ex: `# GROUPS`, `# PACKAGE`, `# TERMINAL`)

**O que é ADICIONADO:**
- `source` de `common/git.sh` no lugar do bloco duplicado
- `source` de `common/editors.sh` (se editores forem mantidos no host)
- `source` de `common/tools.sh` para dotfiles de ferramentas

#### [NEW] [fonts.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/desktop/fonts.sh)

Wrapper mínimo:
```sh
#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/../../common/fonts.sh"
```

Separado do setup porque num servidor sem GUI é inútil, e no desktop é algo que o usuário pode querer re-rodar sem reinstalar tudo.

#### [NEW] [gui.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/desktop/gui.sh)

Contém:
- Setup LY (display manager): ly-wrapper, gettytab, ttys (linhas 55–71)
- Setup SDDM (desabilitar): `sysrc sddm_enable=NO` (linhas 55–57)
- Setup Xorg: `.xinitrc` (linhas 73–76)
- Setup Konsole Profiles **FreeBSD-específicos** (linhas 259–331):
  - `Shell.profile`: `Command=/bin/sh`, `Environment=SHELL_INIT=1,SHELL_TARGET=/bin/sh`
  - `Bash.profile`: `Command=/usr/local/bin/bash`
  - `Zsh.profile`: `Command=/usr/local/bin/zsh`

> [!NOTE]
> Os profiles Konsole do FreeBSD **não podem** simplesmente copiar os de `software/terminals/konsole/` (que usam `/bin/bash`, `/bin/zsh`). Eles precisam dos caminhos FreeBSD (`/usr/local/bin/`). Além disso, o FreeBSD tem o `Shell.profile` exclusivo com `SHELL_INIT`.

---

### Etapa 3 — Refatorar FreeBSD Server (`setup.sh`)

#### [REFACTOR] [setup.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/server/setup.sh)

O script atual tem **363 linhas** e também instala dev tools no host.

**O que permanece:**
- Setup System (Root): groups, pkg bootstrap, qemu-guest-agent, terminal, sudo, doas (linhas 1–38)
- Setup Environment (Root): coredump (linhas 40–49)
- Setup Shell: bash, zsh (linhas 52–58)
- Setup Wget/Curl (linhas 60–67)
- Setup Git → **substituir** por `source common/git.sh` (linhas 69–89)
- Setup Ports (linhas 91–101) — melhorar com `git -C`
- Setup Jails + Bastille (linhas 103–118)
- Config Shell: chsh (linhas 121–128)
- Needed Tools: mandoc, zip/unzip/7-zip, gnupg/openssl/libressl (linhas 130–151) — **remover cmake, ninja, meson**
- Rust Tools: eza, fd, bat, grex, ripgrep (linhas 153–163) — **remover `eza` duplicado**
- System Fetch: fastfetch (linhas 165–174) — **remover neofetch**
- Web/Net Tools (linhas 176–187)
- TreeSitter: **remover**
- Terminal Editors: **manter apenas neovim, vim, helix, micro, nano** (os mais leves)
- Editor configs → `source common/editors.sh` (server variant)

**O que é REMOVIDO:**
- ❌ "Installing Languages" (linhas 340–362): gcc, llvm, nasm, fasm, python, lua — container
- ❌ `neofetch` (abandonado)
- ❌ `cmake`, `ninja`, `meson` — build systems = container
- ❌ `eza` duplicado
- ❌ Comentários `#` literais

---

### Etapa 4 — Remover `source vault` de Todos os Scripts

Com base na pesquisa, as ocorrências de `source vault` no repositório são:

| Arquivo | Linha | Tipo | Ação |
|---|---|---|---|
| [freebsd/desktop/setup.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/desktop/setup.sh) | 342, 351 | heredoc de `frigo-server`/`orbs-server` | Remover `source` → usar variáveis diretamente |
| [linux/desktop/arch/setup.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/linux/desktop/arch/setup.sh) | 419, 427 | heredoc de `frigo-server`/`orbs-server` | Remover `source` → usar variáveis diretamente |
| [arch-linux.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/arch-linux.sh) (legado) | 414, 422 | heredoc de `frigo-server`/`orbs-server` | Remover `source` (ou deletar script inteiro se legado) |
| [windows/msys2/setup.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/windows/msys2/setup.sh) | 19, 26 | heredoc de `frigo-server`/`orbs-server` | Remover `source` |
| [nushell/config.nu](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/software/terminals/nushell/config.nu) | 9 | `source ~/.vault/vault.nu` | Remover (se Vault é global) |

**Para os heredocs de server wrappers**, a refatoração é:

```diff
-#!/usr/local/bin/zsh
-source "${HOME}/.vault/servers/servers.env"
-ssh -i "${FRIGO_SERVER_KEY}" "ubuntu@${FRIGO_SERVER_IP}"
+#!/bin/sh
+ssh -i "${FRIGO_SERVER_KEY}" "ubuntu@${FRIGO_SERVER_IP}"
```

> [!CAUTION]
> **Dependência crítica:** Isso só funciona se `$FRIGO_SERVER_KEY` e `$FRIGO_SERVER_IP` estiverem disponíveis no ambiente quando o wrapper for invocado. Se o Vault é carregado via shell RC files (`.zshrc`), essas variáveis **existem no shell interativo** mas **não num script `/bin/sh`**. Nesse caso, a melhor abordagem seria fazer os heredocs expandirem as variáveis em **tempo de geração** (não de execução), ou seja, usar heredoc **sem** quotes (`<< EOF` em vez de `<< 'EOF'`), resolvendo os valores no momento do bootstrap.

---

### Etapa 5 — Limpeza de Comentários e Auditoria Final

Aplicar consistentemente em todos os arquivos tocados:

1. **Remover comentários `#` literais** (ex: `# GROUPS`, `# PACKAGE`, `# SHELL`, `# WGET`)
2. **Manter blocos visuais** `### ################################` como separadores de seção
3. **Remover `# WordMode=true` comentado** nos Konsole profiles (linhas 272, 295, 318)
4. **Remover `eza` duplicado** no FreeBSD desktop (linhas 389 e 392) e server (linhas 158 e 161)
5. **Remover `neofetch`** (projeto abandonado, substituído por `fastfetch`)
6. **Remover `elinks`** (avaliar se ainda é necessário tendo `w3m` e `lynx`)
7. **Auditar redundâncias**: `openssl` vs `libressl` (ambos instalados simultaneamente)

---

## Documentação — Incrementar `/docs`

#### [NEW] [docs/BOOTSTRAP.md](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/docs/BOOTSTRAP.md)

Criar um doc novo explicando a **estratégia de modularização do bootstrap**, descrevendo:
- O papel de `common/` (lógica compartilhada, nunca executada diretamente)
- A regra de "poucos scripts, zero duplicação"
- Como adicionar um novo SO ao bootstrap
- A tabela de quais scripts o usuário precisa executar por perfil (desktop/server)

#### [MODIFY] [docs/BSD.md](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/docs/BSD.md)

Adicionar seção sobre:
- Konsole profiles: explicar por que FreeBSD tem `Shell.profile` exclusivo e caminhos `/usr/local/bin/`
- O fato de que LY é o display manager padrão no FreeBSD (em vez de SDDM)

#### [MODIFY] [bootstrap/README.md](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/README.md)

Atualizar com a nova estrutura de diretórios e mencionar `common/`.

#### [MODIFY] [docs/VAULT.md](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/docs/VAULT.md)

Atualizar para refletir que `source ~/.vault/config.env` não é mais necessário nos scripts. Documentar que o Vault é carregado globalmente pelo ecossistema Shell.

---

## Verification Plan

### Automated Tests

Não existem testes automatizados neste repositório (é infraestrutura de bootstrap). Verificação será por:

```bash
# Verificar que nenhum script restante faz source de vault
grep -r "source.*vault" bootstrap/
grep -r "source.*vault" software/

# Verificar que não há pacotes de dev no FreeBSD host
grep -E "gcc|llvm|rust|zig|go|nasm|fasm|deno|nodejs|npm|python|lua" bootstrap/freebsd/desktop/setup.sh
grep -E "gcc|llvm|nasm|fasm|python|lua" bootstrap/freebsd/server/setup.sh

# Verificar que common/ é usado
grep -r "common/" bootstrap/freebsd/
```

### Manual Verification

- Revisão visual de cada arquivo modificado (arquivo por arquivo, conforme solicitado)
- Validação de que os Konsole profiles do FreeBSD mantêm caminhos `/usr/local/bin/`
- Conferência de que o `bootstrap/common/git.sh` existente usa as mesmas variáveis (`$GIT_AUTHOR_EMAIL`, `$GIT_AUTHOR_NAME`) e não as hardcoded (`"${GIT_EMAIL}"`)
- Contagem de linhas antes/depois para confirmar redução de código

---

## Resumo de Impacto

| Métrica | Antes | Depois (estimado) |
|---|---|---|
| Linhas FreeBSD desktop `setup.sh` | 769 | ~250 |
| Linhas FreeBSD server `setup.sh` | 363 | ~150 |
| Arquivos em `bootstrap/common/` | 1 | 4 |
| Ocorrências de `source vault` | 11 | 0 |
| Blocos de código duplicados | ~8 blocos | 0 |
| Linguagens de dev no host FreeBSD | 10+ | 0 |
