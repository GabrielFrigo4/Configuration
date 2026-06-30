# Walkthrough — Refatoração FreeBSD + Vault

## Resumo das Mudanças

### Arquivos Criados (14)
| Arquivo | Descrição |
|---|---|
| [common/fonts.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/common/fonts.sh) | Nerd Fonts compartilhado (UNIX-wide) |
| [common/tools.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/common/tools.sh) | Deploy de dotfiles via `cp` de `software/tools/` |
| [freebsd/desktop/fonts.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/desktop/fonts.sh) | Wrapper: Microsoft fonts + source common |
| [freebsd/desktop/gui.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/desktop/gui.sh) | LY, SDDM, Xorg, Konsole profiles (FreeBSD paths) |
| [freebsd/dev/cpp.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/dev/cpp.sh) | C/C++ + build systems (para Jails) |
| [freebsd/dev/rust.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/dev/rust.sh) | Rust (para Jails) |
| [freebsd/dev/go.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/dev/go.sh) | Go (para Jails) |
| [freebsd/dev/zig.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/dev/zig.sh) | Zig (para Jails) |
| [freebsd/dev/asm.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/dev/asm.sh) | Assembly (para Jails) |
| [freebsd/dev/js.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/dev/js.sh) | JavaScript/Node.js (para Jails) |
| [freebsd/dev/python.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/dev/python.sh) | Python (para Jails) |
| [freebsd/dev/lua.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/dev/lua.sh) | Lua (todas as versões, para Jails) |
| [freebsd/dev/lsp.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/dev/lsp.sh) | LSP servers e formatters (para Jails) |
| [docs/BOOTSTRAP.md](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/docs/BOOTSTRAP.md) | Nova documentação da arquitetura do bootstrap |

### Arquivos Refatorados (5)
| Arquivo | Antes | Depois | O que mudou |
|---|---|---|---|
| [freebsd/desktop/setup.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/desktop/setup.sh) | 769 linhas | ~210 linhas | Removido: dev langs, LSPs, fonts, GUI, Konsole, heredocs de tools, vault source, eza duplicado, neofetch, tree-sitter, cmake/ninja/meson |
| [freebsd/server/setup.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/freebsd/server/setup.sh) | 363 linhas | ~155 linhas | Removido: dev langs, vault (implícito pelo common/git.sh), neofetch, tree-sitter, cmake/ninja/meson, eza duplicado |
| [linux/desktop/arch/setup.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/linux/desktop/arch/setup.sh) | 1148 linhas | 1144 linhas | Removido: vault source dos heredocs de frigo/orbs-server |
| [windows/msys2/setup.sh](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/windows/msys2/setup.sh) | 688 linhas | 686 linhas | Removido: vault source dos heredocs de frigo/orbs-server |
| [bootstrap/README.md](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/bootstrap/README.md) | 23 linhas | 36 linhas | Nova estrutura de diretórios + link para BOOTSTRAP.md |

### Documentação Atualizada (3)
| Arquivo | O que foi adicionado |
|---|---|
| [docs/BSD.md](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/docs/BSD.md) | Seções sobre Konsole profiles (Shell.profile exclusivo) e LY display manager |
| [docs/VAULT.md](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/docs/VAULT.md) | Carregamento automático via Shell, exceção Windows (Nushell/PowerShell) |
| [docs/README.md](file:///c:/Users/gabriel.frigo/Documents/GitHub/Configuration/docs/README.md) | Referência ao novo BOOTSTRAP.md |

### Arquivos Deletados (2)
| Arquivo | Motivo |
|---|---|
| `bootstrap/arch-linux.sh` | Legado — duplicata de `linux/desktop/arch/setup.sh` |
| `bootstrap/ubuntu.sh` | Legado — duplicata de `linux/desktop/debian/setup.sh` |

## Validação

- ✅ **0 ocorrências** de `source vault` em `bootstrap/`
- ✅ **0 linguagens de desenvolvimento** nos setup scripts do FreeBSD host
- ✅ **0 duplicatas** de `eza` nos setup scripts
- ✅ Konsole profiles mantêm caminhos FreeBSD (`/usr/local/bin/`)
- ✅ `Shell.profile` preservado como exclusivo do FreeBSD
- ✅ `common/git.sh` usa variáveis do Vault (`$GIT_AUTHOR_EMAIL`, `$GIT_AUTHOR_NAME`)
- ✅ Windows Nushell/PowerShell vault source **não foi tocado** (exceção intencional)

## Pendente

A refatoração completa dos scripts Linux (`arch/setup.sh` e `debian/setup.sh`) para usar `common/` (fonts, editors, tools) ficou para uma próxima rodada. O vault já foi removido deles.
