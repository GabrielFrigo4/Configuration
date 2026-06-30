# Tasks — Refatoração FreeBSD + Vault

## Etapa 1 — Criar `bootstrap/common/`
- [x] `common/fonts.sh` — Nerd Fonts compartilhado
- [x] `common/tools.sh` — Deploy de dotfiles (`cp` de `software/tools/`)
- [x] Verificar `common/git.sh` — Já usa variáveis do Vault corretamente

## Etapa 2 — Criar `bootstrap/freebsd/dev/`
- [x] `dev/cpp.sh` — gcc, llvm, cmake, ninja, meson
- [x] `dev/rust.sh` — rust
- [x] `dev/go.sh` — go
- [x] `dev/zig.sh` — zig
- [x] `dev/asm.sh` — nasm, fasm
- [x] `dev/js.sh` — deno, nodejs, npm
- [x] `dev/python.sh` — python
- [x] `dev/lua.sh` — lua (todas as versões), luajit
- [x] `dev/lsp.sh` — gopls, stylua, prettier, asm-lsp

## Etapa 3 — Refatorar FreeBSD Desktop
- [x] Criar `freebsd/desktop/fonts.sh` (wrapper de common)
- [x] Criar `freebsd/desktop/gui.sh` (LY, SDDM, Xorg, Konsole FreeBSD)
- [x] Refatorar `freebsd/desktop/setup.sh` (769 → ~210 linhas)

## Etapa 4 — Refatorar FreeBSD Server
- [x] Refatorar `freebsd/server/setup.sh` (363 → ~155 linhas)

## Etapa 5 — Remover `source vault` de Todos os Scripts
- [x] `freebsd/desktop/setup.sh` — heredocs frigo/orbs-server (removidos no refactor)
- [x] `linux/desktop/arch/setup.sh` — heredocs frigo/orbs-server
- [x] `windows/msys2/setup.sh` — heredocs frigo/orbs-server
- [x] Verificação: 0 ocorrências de `source vault` em bootstrap/

## Etapa 6 — Limpeza de Legados e Linux
- [x] Deletar `bootstrap/arch-linux.sh` (legado)
- [x] Deletar `bootstrap/ubuntu.sh` (legado)
- [ ] Refatorar `linux/desktop/arch/setup.sh` (usar common/ para fonts/editors/tools)
- [ ] Refatorar `linux/desktop/debian/setup.sh` (usar common/ para fonts/editors/tools)

## Etapa 7 — Documentação
- [x] Criar `docs/BOOTSTRAP.md`
- [x] Atualizar `docs/BSD.md` (Konsole profiles + LY)
- [x] Atualizar `docs/VAULT.md` (carregamento automático + exceção Windows)
- [x] Atualizar `bootstrap/README.md` (nova estrutura + link para BOOTSTRAP.md)
- [x] Atualizar `docs/README.md` (adicionar BOOTSTRAP.md ao índice)
