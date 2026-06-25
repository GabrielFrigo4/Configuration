# Ambiente KDE (Plasma)

Anotações e dicas sobre o ambiente gráfico KDE Plasma, utilizado primariamente no Arch Linux e no Debian neste repositório.

## Versão do KDE

O repositório é otimizado para o **KDE Plasma 6**, garantindo suporte às versões mais recentes do ambiente e do ecossistema Qt6.

## Polkit

[Polkit](https://en.wikipedia.org/wiki/Polkit) (anteriormente PolicyKit) é um componente para controlar privilégios em todo o sistema em sistemas operacionais do tipo Unix. Ele fornece uma maneira organizada para que processos não privilegiados se comuniquem com os privilegiados. O Polkit permite um nível de controle da política do sistema centralizado.

### Autenticação Gráfica

Para garantir que janelas que solicitam permissão de root (como o GParted, ou outros utilitários) funcionem corretamente e não falhem com erros de Polkit, é necessário que o agente de autenticação esteja rodando.

**Caminho do Agente:**
`/usr/lib/polkit-kde-authentication-agent-1`

### pkexec

O `pkexec` permite executar comandos ou aplicações gráficas como outro usuário (geralmente root) utilizando a infraestrutura do Polkit para a caixa de diálogo de autenticação.

Exemplo de uso:

```bash
pkexec gparted
```

## Dicas Adicionais (Wayland vs X11)

A partir do KDE Plasma 6, a sessão padrão passou a ser o **Wayland**. Isso influencia como as configurações de tela e aplicativos funcionam.

- Certifique-se de usar variáveis ambientais corretas se precisar rodar aplicativos X11 antigos ou se houver problemas de escalonamento (`QT_QPA_PLATFORM=wayland`).
- O Konsole possui suporte completo ao Wayland, com escalonamento nítido e bom desempenho.
