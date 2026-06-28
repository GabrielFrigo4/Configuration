# Configuration

Repositório central de configurações de software, ferramentas de desenvolvimento e scripts de bootstrap do sistema.

## 🧠 Filosofia e Arquitetura

Este projeto não é apenas um repositório de "dotfiles", mas a base de uma arquitetura estrita e bem definida baseada em três pilares centrais:

1. **"Clean Host" (Isolamento Extremo):** O sistema operacional nativo (o _host_) deve permanecer o mais puro e limpo possível. Ele é responsável **apenas** por prover a interface gráfica (Wayland/X11, via KDE Plasma), os drivers de hardware, os editores de código (IDEs) e a camada de virtualização/hypervisor. Nenhuma linguagem de programação, banco de dados ou framework de desenvolvimento é instalado diretamente no host.
2. **"Uma coisa, um lugar" (Modularidade):** O ecossistema é quebrado em repositórios e módulos distintos. A configuração do sistema está estritamente separada do comportamento dinâmico do terminal e do gerenciamento de segredos.
3. **Reprodutibilidade e Segurança:** Uso massivo do sistema de arquivos **ZFS** como base para snapshots, criptografia nativa e restauração rápida, aliado a tecnologias de isolamento (Jails/Containers/Hypervisors).

> 📖 **Leitura Obrigatória:** Para entender a essência deste ecossistema, leia o documento de [Filosofia (PHILOSOPHY.md)](docs/PHILOSOPHY.md) e os detalhes sobre [Containers](docs/CONTAINERS.md) e [Hypervisors](docs/HYPERVISORS.md).

## 📂 Estrutura do Projeto

- **[`bootstrap/`](bootstrap/README.md)** — Scripts de instalação e provisionamento inicial de sistemas operacionais limpos (Arch Linux, Debian, FreeBSD, Windows). Automatizam a instalação do ecossistema base (ZFS, ferramentas de virtualização, rede).
- **[`software/`](software/README.md)** — Configurações estáticas e "dotfiles" dos softwares do host.
    - **`editors/`** — Instalação e profiles (Emacs, NeoVim, Helix, VS Code, etc).
    - **`terminals/`** — Perfis e configurações estáticas de terminal (Konsole, Windows Terminal).
    - **`tools/`** — Configuração global de formatadores e linters essenciais do host.
- **[`scripts/`](scripts/README.md)** — Scripts utilitários para tarefas gerais do sistema operacional.
- **[`docs/`](docs/README.md)** — Toda a documentação detalhada da arquitetura, hypervisors, conteinerização e especificidades de ambientes (BSD, KDE).

## 🚀 Getting Started

Este repositório foi construído para não exigir nenhuma dependência prévia do sistema além de uma instalação limpa e o comando `git`.

1. Clone o repositório na sua máquina recém-instalada.
2. Navegue até o diretório correspondente ao seu sistema operacional dentro de `bootstrap/`.
3. Execute o script mestre de instalação para configurar automaticamente pacotes base, ZFS, hypervisors e dependências do ambiente.
4. Após o bootstrap do sistema, aplique as configurações dentro de `software/`.

## 🔗 O Ecossistema da Tríade

Este repositório trabalha em conjunto com outras duas peças fundamentais que completam o sistema:

- **[Shell](https://github.com/GabrielFrigo4/Shell)**: Scripts utilitários, comportamento ativo, aliases e lógicas dinâmicas de terminal. Diferente de configurações estáticas, aqui vive o "motor" do shell. Veja a [documentação do Shell](docs/SHELL.md).
- **[Vault](https://github.com/GabrielFrigo4/Vault)** (Privado): O cofre do ecossistema. Gerenciamento estrito de chaves SSH, credenciais, e variáveis de ambiente sensíveis. Veja a [documentação do Vault](docs/VAULT.md).
