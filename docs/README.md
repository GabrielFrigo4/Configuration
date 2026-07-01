# Documentação do Repositório

Esta pasta contém o detalhamento arquitetural, técnico e filosófico de todo o ambiente provisionado por este repositório. O entendimento destes documentos é fundamental para a manutenção correta do projeto.

## A Bíblia do Projeto

- **[PHILOSOPHY.md](PHILOSOPHY.md)** — A regra de ouro: "Clean Host", ZFS e Modularidade (Configuration vs Shell vs Vault). Leia este primeiro.

## Infraestrutura e Isolamento

- **[BOOTSTRAP.md](BOOTSTRAP.md)** — Arquitetura de modularização dos scripts de bootstrap: o papel de `common/`, `dev/`, e a regra "poucos scripts, zero duplicação".
- **[CONTAINERS.md](CONTAINERS.md)** — Isolamento de SO sem VMs pesadas. Documentação sobre Bastille/Jails (FreeBSD) e Incus/LXC (Linux).
- **[HYPERVISORS.md](HYPERVISORS.md)** — Virtualização completa, ZVOLs e a estratégia de hardware. bhyve (FreeBSD), KVM (Linux) e Hyper-V/WSL2 (Windows).

## O Ecossistema (A Tríade)

Além deste repositório de `Configuration`, outros dois repositórios complementam o sistema. Entenda como eles se integram:

- **[SHELL.md](SHELL.md)** — Regras sobre quais shells usamos (sh, bash, zsh vs pwsh, nushell) e onde o repositório ativo "Shell" deve ser instalado.
- **[VAULT.md](VAULT.md)** — Gerenciamento de credenciais privadas, tokens e chaves seguras.

## Notas sobre Ambientes Específicos

- **[BSD.md](BSD.md)** — Particularidades vitais do FreeBSD (Caminhos em `/usr/local/`, Jails e perfis Konsole).
- **[KDE.md](KDE.md)** — Dicas sobre o ambiente gráfico (Plasma Wayland/X11, pkexec e Polkit).
- **[FIREFOX.md](FIREFOX.md)** — Configurações manuais do Firefox (Clipboard API, about:config).
