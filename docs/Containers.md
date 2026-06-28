# 📦 Containers e Isolamento de SO

Conforme ditado pelo documento de [Filosofia](PHILOSOPHY.md), a abordagem primária para ambientes de desenvolvimento não isolados via hardware real (VMs pesadas) é o uso de **Containers de Sistema**. Diferente do Docker (que foca em containers de aplicação única), focamos em containers de sistema que se comportam como máquinas virtuais leves.

A grande vantagem de usar containers de sistema é a agilidade: eles sobem em segundos, consomem muito menos memória que um hypervisor, e ainda assim proporcionam um isolamento profundo do sistema operacional host. Eles são a base para termos bancos de dados, servidores web e diferentes toolchains rodando na mesma máquina, sem sujá-la.

## O Papel do ZFS nos Containers

Tanto no FreeBSD quanto no Linux, os diretórios base dos containers devem residir em datasets do **ZFS**. Isso permite:

1. Snapshots instantâneos (ex: "faça um backup desse banco de dados no container antes de eu rodar esta migration arriscada").
2. Clones imediatos de containers inteiros sem consumir espaço em disco extra até que os dados sejam modificados.
3. Resiliência de dados e checksums em tempo real.

## FreeBSD: Jails & Bastille

O FreeBSD é o berço nativo dos Jails, indiscutivelmente uma das tecnologias de isolamento de processos e redes mais antigas e robustas do mundo UNIX.

- **Tecnologia Base:** FreeBSD Jails. O kernel do FreeBSD garante isolamento quase impenetrável sem a complexidade de gerenciar namespaces independentes como no Linux.
- **Gerenciador:** **[BastilleBSD](https://bastillebsd.org/)**. Bastille é a ferramenta moderna para criar, gerenciar e fazer bootstrap de jails no FreeBSD. Ele simplifica enormemente o provisionamento, permitindo a criação de templates e scripts para instanciar ambientes de desenvolvimento em segundos.
- **Uso:** Ideal para rodar serviços de backend, compilação isolada ou até mesmo bancos de dados nativos no ambiente FreeBSD.

## Linux: LXC & Incus

No mundo Linux, usamos o Linux Containers (LXC), gerenciados primariamente pelo **Incus**.

- **Tecnologia Base:** LXC (namespaces, cgroups).
- **Gerenciador:** **[Incus](https://linuxcontainers.org/incus/)**. Nascido de um fork do LXD mantido pela própria comunidade Linux Containers, o Incus é a ponte que gerencia tanto containers de sistema quanto VMs completas sob uma única API e CLI amigável.
- **Uso:** Incus provê a experiência de "spin-up" de um sistema completo (Arch, Debian, Alpine) em menos de 2 segundos, rodando nativamente sobre o kernel do host.

---

**Resumo da Regra:** Precisa de um Node.js versão X e um PostgreSQL versão Y? Não instale no host. Instale dentro de uma Jail (Bastille) ou um Container (Incus).
