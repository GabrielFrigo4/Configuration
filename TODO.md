# Planos Futuros (TODO)

Este documento centraliza as próximas evoluções arquiteturais e de limpeza planejadas para este repositório de configuração.
Todas as ações aqui descritas são guiadas pela busca da nossa filosofia principal: atingir um **"Clean Host"** puramente funcional, com desenvolvimento 100% isolado em **Containers/Hypervisors**, e garantir a total modularidade dos nossos 3 pilares (Configuration, Shell, Vault).

## 1. Dependências do Vault

- Remover chamadas manuais de `source ~/.vault/config.env` espalhadas pelos scripts.
- Como o Vault (e o Shell) agora são carregados automaticamente pelo ambiente, refatorar os códigos para que eles apenas consumam as variáveis, assumindo que o ecossistema já as proveu globalmente.

## 2. Modularização do Bootstrap

- Modularizar intensamente o diretório `/bootstrap`.
- Quebrar os scripts monolíticos legados em componentes menores, reaproveitáveis e organizados, similar ao modelo focado de "uma coisa, um lugar".

## 3. Refatoração FreeBSD

- Extrair os heredocs de criação de arquivos do FreeBSD, seguindo a mesma estratégia de refatoração aplicada ao Linux e ao Windows.
- **Atenção especial:** O Konsole no FreeBSD não é igual ao do Linux (por exemplo, paths e shells diferem, como `/usr/local/bin/zsh`), exigindo profiles adaptados e não apenas cópias diretas.

## 4. Limpeza de Comentários

- Fazer uma varredura para remover comentários `#` (shell) ou `rem` (cmd) desnecessários ou excessivamente literais em todos os scripts.
- Focar no padrão visual já estabelecido de blocos delimitadores com múltiplos caracteres (`### ################################`) para separar as seções, mantendo o código conciso e legível.

## 5. Auditoria de Softwares

- Limpar comandos redundantes.
- Remover pacotes e softwares desnecessários que possam estar inflando os scripts de instalação e poluindo o sistema do host.

## 6. Evolução para Containers

- Alterar a filosofia do ambiente para um modelo focado em **Containers** em vez de instalar e jogar todas as dependências de desenvolvimento e banco de dados diretamente no host.
- Atingir sistemas compatíveis como Linux e FreeBSD (para o Windows não haverá grandes mudanças nesse escopo específico).
