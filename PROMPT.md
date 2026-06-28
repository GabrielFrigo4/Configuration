# Contexto do Projeto e Filosofia
Você está trabalhando em um repositório de configurações de sistema (dotfiles/bootstrap) focado em uma arquitetura de "Clean Host". O objetivo é manter o sistema operacional base o mais puro possível, delegando o desenvolvimento para Containers/Hypervisors e gerenciando segredos e ambiente dinâmico através de módulos separados (Vault e Shell).

# Objetivo da Tarefa
Precisamos que você elabore um plano de execução detalhado e passo a passo focado EXCLUSIVAMENTE nos itens 1 e 3 do nosso arquivo `TODO.md`. O escopo principal de atuação será o sistema **FreeBSD** e a integração com o **Vault**.

## Escopo Principal (O que deve ser executado):
- **Item 1 (Dependências do Vault):** Remover todas as chamadas manuais de `source ~/.vault/config.env` dos nossos scripts. O Vault (assim como o Shell) agora é carregado globalmente. Seu plano deve prever a refatoração do código para que os scripts apenas consumam as variáveis de ambiente, assumindo sua existência prévia.
- **Item 3 (Refatoração FreeBSD):** Refatorar os scripts focados no FreeBSD (como os presentes em `bootstrap/freebsd/`). Precisamos extrair os "heredocs" responsáveis pela criação de arquivos, seguindo o padrão de modularização já adotado. Além disso, ter atenção especial aos perfis do Konsole no FreeBSD, pois eles exigem caminhos adaptados (ex: shell usando `/usr/local/bin/zsh`) e não podem ser meras cópias do Linux.

## Restrições e Guias Arquiteturais (O que ter em mente):
Ao planejar e (posteriormente) implementar os itens 1 e 3, você DEVE obrigatoriamente aplicar os princípios dos itens 2, 4, 5 e 6 do `TODO.md` em todas as suas modificações:
- **Item 2 (Modularização):** Ao mexer nos scripts de bootstrap, divida componentes monolíticos legados em partes menores e reaproveitáveis.
- **Item 4 (Limpeza de Comentários):** Durante a edição, remova comentários literais ou desnecessários (`#`). Mantenha e reforce o uso de blocos visuais (`### ################################`) para separação de seções lógicas.
- **Item 5 (Auditoria de Softwares):** Remova pacotes instalados desnecessários ou comandos redundantes que inflem o script e poluam o sistema host.
- **Item 6 (Evolução para Containers):** Certifique-se de que não estamos instalando ferramentas de desenvolvimento, linguagens ou bancos de dados diretamente no host do FreeBSD. O ambiente deve ser preparado para que tudo isso rode via Containers.

# Instruções de Entrega
1. Analise o estado atual dos scripts FreeBSD no repositório.
2. Forneça o **Plano de Execução** organizado em tópicos lógicos e etapas claras.
3. Não inicie a codificação em massa ainda. Apresente o plano para aprovação e, quando aprovado, solicitaremos as alterações arquivo por arquivo.
