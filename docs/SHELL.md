# 🐚 Shell Ecosystem

O repositório **[Shell](https://github.com/GabrielFrigo4/Shell)** é o "motor dinâmico" do ecossistema. Ele contém scripts utilitários, aliases globais, funções e lógicas de terminal de uso diário que complementam este repositório estático (`Configuration`).

Enquanto o `Configuration` cuida de arquivos estáticos, o `Shell` injeta vida no terminal.

## 📂 Localização de Instalação

O repositório Shell é clonado em caminhos diferentes de acordo com a plataforma em uso. Seu terminal deve ser configurado para consumir e carregar (`source`) os arquivos do Shell nestas localidades:

| Plataforma                             | Caminho Padrão           |
| :------------------------------------- | :----------------------- |
| **UNIX (Linux, FreeBSD, macOS, WSL2)** | `/usr/local/share/shell` |
| **Windows (MSYS2)**                    | `~/.shell`               |

## 🛠️ A Matriz de Shells Suportados

Para manter a consistência e a manutenção sob controle, limitamos rigorosamente quais shells utilizamos e suportamos em cada ambiente. Evitamos "over-engineering" e focamos nos interpretadores mais maduros de cada ecossistema:

### Ambientes UNIX (Linux, FreeBSD, macOS, WSL2)

Nesses ambientes, confiamos inteiramente nos clássicos resilientes e universais:

- **`sh`** (Bourne shell original, usado para scripts de bootstrap ultra-portáteis e rígidos).
- **`bash`** (Para scripts mais complexos que exigem arrays e utilitários modernos).
- **`zsh`** (Para uso interativo diário).

_Nota sobre o FreeBSD:_ Lembre-se de que `bash` e `zsh` vivem em `/usr/local/bin/`, conforme detalhado em [BSD.md](BSD.md).

### Ambientes Windows Nativo

No Windows nativo, abandonamos as pontes de compatibilidade POSIX para abraçar o ecossistema moderno da Microsoft e ferramentas que dão vida ao prompt:

- **`cmd`** (Essencial para integrações legadas e `bootstrap/` cru).
- **`pwsh` (PowerShell Core)** (A espinha dorsal das nossas automações em Windows).
- **`clink`** (Para adicionar superpoderes readline e completions ao `cmd` antigo).
- **`nushell`** (Terminal altamente estruturado para manipulação de dados moderna).

### Ambiente Windows MSYS2

Quando precisamos de um ambiente UNIX falso dentro do Windows, usamos o MSYS2. Nele, restringimos o uso estritamente aos clássicos:

- **`bash`**
- **`zsh`**

Qualquer script deste repositório (`Configuration`) invoca essas shells específicas conforme a matriz acima.
