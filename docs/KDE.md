# 🖥️ Ambiente KDE (Plasma) e a Camada do Host

A interface gráfica é o componente mais pesado que tem a permissão de rodar diretamente no _Host_ (conforme as diretrizes de [Filosofia](PHILOSOPHY.md)). Escolhemos o **KDE Plasma 6** por oferecer a melhor integração entre Wayland moderno, customização absoluta e suporte sólido a ferramentas gráficas.

## Por que o KDE no Host Limpo?

Manter o KDE diretamente no host (seja no Arch, Debian ou FreeBSD) garante que a aceleração de hardware (GPU), drivers de vídeo e gerenciamento de monitores ocorram sem overhead de virtualização, entregando o desempenho nativo necessário para rodar nossos hypervisors, Jails e Incus confortavelmente.

## Segurança e Wayland

A partir do KDE Plasma 6, a sessão padrão utilizada é o **Wayland**. Isso corrobora perfeitamente com a nossa filosofia de segurança e isolamento.

- **Isolamento de Janelas:** Diferente do X11, onde qualquer programa (keylogger, app antigo) pode ler a tela de outros aplicativos, o Wayland isola as superfícies graficas estritamente.
- **Variáveis Ambientais:** Certifique-se de usar `QT_QPA_PLATFORM=wayland` se precisar forçar aplicativos teimosos (mas lembre-se, quase tudo que não é editor roda isolado num container de qualquer forma).
- O **Konsole** possui suporte de primeira classe ao Wayland, provendo escalonamento e renderização nítidos para interagir com a infraestrutura.

## Polkit: Gerenciamento de Privilégios

Como não fazemos login de `root` para utilizar a interface gráfica, e limitamos ao máximo o uso do `sudo` indiscriminado no host, dependemos fortemente do **Polkit** (PolicyKit) para autorizar ações específicas (como gerenciar redes ou partições).

### Autenticação Gráfica

Para garantir que janelas que solicitam permissões (como o GParted, ou utilitários de discos ZFS) não quebrem silenciosamente, o agente de autenticação deve estar rodando em background.

**Caminho do Agente (Arch Linux/Debian):**
`/usr/lib/polkit-kde-authentication-agent-1`

_(Se você notar que popups de senha não estão aparecendo no KDE, é porque esse agente falhou em iniciar)_.

### pkexec

Para rodar aplicações gráficas esporádicas no host com permissão de root, evite o `sudo` puro e utilize o `pkexec`. Ele invoca a janela gráfica padrão do KDE (via Polkit) para autorização, mantendo a consistência do ambiente gráfico.

Exemplo seguro:

```bash
pkexec gparted
```
