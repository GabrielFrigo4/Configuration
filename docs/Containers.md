# 📦 Arquitetura de Containers (Isolamento)

A visão de longo prazo para este ambiente de desenvolvimento é a mudança para uma filosofia estrita focada em **Containers**.

Em vez de instalar e jogar dezenas de linguagens, bancos de dados e frameworks (ex: Node, Python, Postgres) diretamente no _host_, utilizamos tecnologias de containerescimento para manter o sistema operacional original o mais puro possível.

## Filosofia "Clean Host"

O _host_ (máquina principal física) é responsável apenas por prover a interface gráfica (Wayland/X11, KDE), drivers, os editores de código e o _hypervisor_ (ou agente de virtualização). Todo projeto rodará isolado.

As vantagens desta abordagem incluem:

- **Reprodutibilidade:** Se você precisar configurar um note velho na praia, seu projeto subirá idêntico ao desktop de casa, provendo as próprias dependências.
- **Limpeza Fácil:** Deletar um projeto remove todas as sujeiras do sistema associadas a ele. Não ficam pacotes órfãos ou versões conflitantes de linguagens.
- **Portabilidade Multi-Plataforma:** Padronização do fluxo de trabalho indepentente do sistema hospedeiro.

## Tecnologias Alvo

- **FreeBSD**: Utilização extensiva de `jails`.
- **Linux**: Foco no `LXC` (Linux Containers) gerenciado pelo [Incus](https://linuxcontainers.org/incus/). O Incus provê containers de sistema (não apenas containers de aplicação como o Docker), atuando como máquinas virtuais leves.

A configuração e instalação dessas bases de virtualização já são contempladas nos scripts da pasta `bootstrap/` do repositório.
