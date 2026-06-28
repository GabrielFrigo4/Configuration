# 🏗️ Bootstrap

Esta pasta contém os scripts fundamentais para inicializar ("bootstrap") uma máquina limpa a partir do zero.

Seguindo nossa filosofia de _Clean Host_ (veja [`docs/PHILOSOPHY.md`](../docs/PHILOSOPHY.md)), a função desses scripts **NÃO** é encher a máquina de linguagens de programação, bancos de dados ou dependências de projetos (que devem viver em Containers/Jails).

A função real destes scripts é:

1. Instalar utilitários básicos de sistema operacional.
2. Preparar a fundação de armazenamento (ZFS).
3. Preparar a fundação de virtualização e containers (Incus, LXC, Bastille, bhyve, Hyper-V).
4. Preparar o ambiente gráfico (KDE Plasma, Wayland).

## Como Usar

Cada subdiretório ou script está agrupado por Sistema Operacional:

- `/arch-linux.sh`
- `/ubuntu.sh`
- `/windows.ps1` / `/windows.cmd`

Geralmente, você deve rodar o script mestre referente à sua plataforma logo após instalar a ISO do sistema e configurar a internet básica.
