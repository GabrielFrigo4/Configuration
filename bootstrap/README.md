# 🏗️ Bootstrap

Esta pasta contém os scripts fundamentais para inicializar ("bootstrap") uma máquina limpa a partir do zero.

Seguindo nossa filosofia de _Clean Host_ (veja [`docs/PHILOSOPHY.md`](../docs/PHILOSOPHY.md)), a função desses scripts **NÃO** é encher a máquina de linguagens de programação, bancos de dados ou dependências de projetos (que devem viver em Containers/Jails).

A função real destes scripts é:

1. Instalar utilitários básicos de sistema operacional.
2. Preparar a fundação de armazenamento (ZFS).
3. Preparar a fundação de virtualização e containers (Incus, LXC, Bastille, bhyve, Hyper-V).
4. Preparar o ambiente gráfico (KDE Plasma, Wayland).

## Estrutura

```
bootstrap/
├── common/         # Lógica compartilhada entre SOs (sourced, nunca executada diretamente)
├── freebsd/
│   ├── desktop/    # FreeBSD com KDE (setup, fonts, gui)
│   ├── server/     # FreeBSD server (setup + connect scripts)
│   └── dev/        # Scripts de desenvolvimento (para Jails/Containers)
├── linux/
│   └── desktop/
│       ├── arch/   # Arch Linux / Manjaro
│       └── debian/ # Debian
└── windows/
    ├── config/     # Configurações do Windows
    ├── msys2/      # Ambiente MSYS2
    └── wsl/        # Windows Subsystem for Linux
```

## Como Usar

Cada subdiretório contém scripts agrupados por Sistema Operacional. Geralmente, execute o script `setup.sh` referente à sua plataforma logo após instalar a ISO do sistema e configurar a internet básica.

Para detalhes sobre a arquitetura de modularização, veja [`docs/BOOTSTRAP.md`](../docs/BOOTSTRAP.md).
