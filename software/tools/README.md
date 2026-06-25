# Tools

Configurações de linters, formatadores e ferramentas de desenvolvimento.

## Arquivos

| Arquivo                  | Ferramenta                | Destino (Linux)                    | Destino (Windows)                              |
| :----------------------- | :------------------------ | :--------------------------------- | :--------------------------------------------- |
| `clangd.yaml`            | Clangd (LSP C/C++)        | `~/.config/clangd/config.yaml`     | `%LOCALAPPDATA%\clangd\config.yaml`            |
| `.clang-format`          | Clang Format              | `~/.clang-format`                  | `%USERPROFILE%\.clang-format`                  |
| `.prettierrc`            | Prettier (JS/TS/HTML/CSS) | `~/.prettierrc`                    | `%USERPROFILE%\.prettierrc`                    |
| `.stylua.toml`           | StyLua (Lua)              | `~/.stylua.toml`                   | `%USERPROFILE%\.stylua.toml`                   |
| `mermaid-puppeteer.json` | Mermaid CLI (Puppeteer)   | `~/.mermaid-puppeteer-config.json` | `%USERPROFILE%\.mermaid-puppeteer-config.json` |
| `mermaid-theme.json`     | Mermaid CLI (Tema)        | `~/.mermaid-theme-config.json`     | `%USERPROFILE%\.mermaid-theme-config.json`     |

## Regras de Estilo

Todas as ferramentas estão configuradas para respeitar as mesmas regras:

- **Column limit**: 96 caracteres
- **Hard Tabs (4)**: Go, Assembly, Makefiles
- **Soft Tabs 2 espaços**: JS, TS, HTML, CSS, JSON, Lua
- **Soft Tabs 4 espaços**: C, C++, Rust, Python, Java

## Instalação Rápida

### Linux

```bash
mkdir -p ~/.config/clangd
cp clangd.yaml ~/.config/clangd/config.yaml
cp .clang-format .prettierrc .stylua.toml ~/
cp mermaid-puppeteer.json ~/.mermaid-puppeteer-config.json
cp mermaid-theme.json ~/.mermaid-theme-config.json
```

### Windows

```cmd
mkdir "%LOCALAPPDATA%\clangd" 2>nul
copy clangd.yaml "%LOCALAPPDATA%\clangd\config.yaml"
copy .clang-format "%USERPROFILE%\.clang-format"
copy .prettierrc "%USERPROFILE%\.prettierrc"
copy .stylua.toml "%USERPROFILE%\.stylua.toml"
copy mermaid-puppeteer.json "%USERPROFILE%\.mermaid-puppeteer-config.json"
copy mermaid-theme.json "%USERPROFILE%\.mermaid-theme-config.json"
```
