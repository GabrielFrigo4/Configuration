# 🏗️ Arquitetura do Bootstrap

Este documento descreve a estratégia de modularização dos scripts de bootstrap e como eles se organizam para atender a diferentes sistemas operacionais e perfis de uso.

## Princípio: "Poucos Scripts, Zero Duplicação"

O bootstrap enfrenta um dilema clássico entre modularização, manutenção e usabilidade:

- **Modularização extrema** (dezenas de micro-scripts) é inviável para um FreeBSD sem GUI, onde copiar/colar comandos é difícil.
- **Scripts monolíticos** (tudo em um arquivo) geram duplicação massiva entre sistemas operacionais.
- **Usabilidade** exige que o usuário rode o mínimo possível de comandos num fresh install.

A solução adotada é manter **poucos scripts executáveis por perfil**, extraindo toda a lógica compartilhada para `bootstrap/common/`.

## Estrutura de Diretórios

```
bootstrap/
├── common/               # Lógica compartilhada (UNIX-wide, sourced internamente)
│   ├── git.sh            # Configuração global do Git (usa variáveis do Vault)
│   ├── fonts.sh          # Instalação de Nerd Fonts
│   └── tools.sh          # Deploy de dotfiles (clangd, clang-format, prettier, stylua)
├── freebsd/
│   ├── desktop/          # FreeBSD com interface gráfica (KDE)
│   │   ├── setup.sh      # Script principal: sistema, pacotes, jails, bastille
│   │   ├── fonts.sh      # Fontes: Microsoft + Nerd Fonts (source common)
│   │   ├── gui.sh        # Display manager (LY), Xorg, Konsole profiles
│   │   ├── config/       # Scripts de configuração de hardware
│   │   ├── bastille/     # Templates de Bastille
│   │   └── docs/         # Erros e TODOs específicos do FreeBSD
│   ├── server/           # FreeBSD server (sem GUI)
│   │   ├── setup.sh      # Script principal: sistema, pacotes, jails, bastille
│   │   └── connect/      # Scripts de conexão SSH/SCP
│   └── dev/              # Scripts de desenvolvimento (para Jails/Containers)
│       ├── cpp.sh        # C/C++ + build systems
│       ├── rust.sh       # Rust
│       ├── go.sh         # Go
│       ├── zig.sh        # Zig
│       ├── asm.sh        # Assembly (nasm, fasm)
│       ├── js.sh         # JavaScript (deno, nodejs, npm)
│       ├── python.sh     # Python
│       ├── lua.sh        # Lua (todas as versões)
│       └── lsp.sh        # LSP servers e formatters
├── linux/
│   └── desktop/
│       ├── arch/         # Arch Linux / Manjaro
│       └── debian/       # Debian
└── windows/
    ├── config/           # Configurações do Windows
    ├── msys2/            # Ambiente MSYS2
    └── wsl/              # Windows Subsystem for Linux
```

## Como Usar

### FreeBSD Desktop (Fresh Install)

Num FreeBSD recém-instalado, o fluxo típico requer no máximo 3 comandos:

```sh
sh setup.sh     # Como root (primeira parte) e depois como user
sh fonts.sh     # Instalar fontes (opcional, só se tiver GUI)
sh gui.sh       # Configurar LY, Xorg e Konsole (opcional, só desktop)
```

### FreeBSD Server

```sh
sh setup.sh     # Um único script faz tudo
```

### Desenvolvimento (dentro de Jails/Containers)

Os scripts em `freebsd/dev/` são executados **dentro** de Jails ou Containers, nunca no host:

```sh
sh dev/cpp.sh     # Instalar C/C++ + build systems
sh dev/rust.sh    # Instalar Rust
sh dev/python.sh  # Instalar Python
```

## O Papel do `common/`

Os scripts em `common/` **nunca** são executados diretamente pelo usuário. Eles são consumidos internamente (via `source` ou `.`) pelos scripts de cada sistema operacional.

Isso elimina duplicação sem sacrificar a experiência do usuário. Por exemplo, a instalação de Nerd Fonts é idêntica entre FreeBSD e Linux — em vez de duplicar ~80 linhas, o script `common/fonts.sh` é sourced por cada wrapper específico do SO.

## Regras para Novos Scripts

1. **Lógica compartilhada** → `common/`
2. **Lógica específica do SO** → dentro do diretório do SO
3. **Ferramentas de desenvolvimento** → `dev/` (nunca no host)
4. **Comentários** → use blocos visuais `### ################################`, não comentários literais `#`
5. **Vault** → as variáveis já estão disponíveis no ambiente; não faça `source` explícito
