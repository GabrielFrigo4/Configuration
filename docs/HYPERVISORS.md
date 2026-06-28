# 🖥️ Hypervisors e Virtualização Completa

Enquanto os [Containers (LXC/Jails)](CONTAINERS.md) são a primeira linha de frente para isolar ambientes de desenvolvimento que compartilham o mesmo kernel que o host, há cenários onde a **virtualização completa de hardware** é essencial.

Hypervisors entram em cena para rodar sistemas operacionais inteiramente distintos (ex: rodar Windows em cima de FreeBSD, ou Linux em cima de Windows), testar kernels customizados ou garantir isolamento absoluto com alocação dedicada de hardware.

Neste repositório, os hypervisors são peças fundamentais da infraestrutura instalada na raiz do host, preparando o terreno para projetos e necessidades diversas.

## O Papel Crítico do ZFS

A sinergia entre Hypervisors e ZFS é imbatível. Em vez de usar imagens `.qcow2` ou `.vmdk` soltas no disco (que sofrem com a sobrecarga do sistema de arquivos tradicional), nossas VMs devem usar **ZVOLs**.

ZVOLs são block devices providos pelo ZFS. Eles expõem o storage bruto diretamente para a VM, garantindo:

- Desempenho significativamente superior comparado a arquivos de imagem.
- Benefícios nativos do ZFS no hardware virtualizado: compressão em tempo real e capacidade de fazer snapshots instantâneos da VM em nível de bloco.
- Capacidade de reverter o estado de uma VM instantaneamente caso ela quebre.

## Soluções por Plataforma

### 1. FreeBSD: bhyve

No FreeBSD, a solução nativa e principal é o **bhyve** (pronuncia-se "bee-hive").

- **O que é:** O hypervisor _Type-2_ construído diretamente no sistema básico do FreeBSD. Ele tira proveito total do isolamento de hardware e é extremamente leve.
- **Por que usamos:** O bhyve é excelente para virtualizar Linux e outras distâncias BSD em cima do seu desktop FreeBSD, com suporte a PCI passthrough (necessário para passar placas de vídeo ou discos diretamente para a VM, caso seja preciso).
- **Gerenciamento:** Ferramentas comunitárias ou scripts próprios (aliados ao ZFS) ajudam a provisionar e gerenciar essas VMs, muitas vezes isolando até mesmo serviços internos que requerem kernels de outros SOs.

### 2. Linux: KVM (Kernel-based Virtual Machine)

No Linux, o **KVM** é a espinha dorsal.

- **O que é:** Transforma o kernel Linux em um hypervisor _Type-1_, oferecendo virtualização de alta performance.
- **Ecossistema:** Utilizado frequentemente em conjunto com o QEMU e ferramentas de gerenciamento como o `libvirt`.
- **Incus:** O Incus, que já usamos para containers (LXC), também é capaz de gerenciar VMs completas utilizando KVM por baixo dos panos. Isso significa que podemos usar a mesma ferramenta (`incus launch ... --vm`) para subir tanto uma VM Ubuntu quanto um container Ubuntu, uniformizando a gestão.

### 3. Windows: Hyper-V / WSL2

Apesar do Windows não ser o foco principal da filosofia de containers modulares, a virtualização aqui é inevitável.

- **WSL2 (Windows Subsystem for Linux):** O WSL2 roda em cima de uma VM leve no Hyper-V. Isso garante um ambiente Linux real e integrado.
- **Hyper-V:** Para virtualizar outros sistemas (BSDs, outras versões do Windows), usamos a funcionalidade nativa do Windows, configurada adequadamente pelos scripts de bootstrap.
