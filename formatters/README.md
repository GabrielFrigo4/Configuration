# Formatters

Arquivos de configuração de linters e formatadores extraídos do `setup.cmd` (antigos blocos BOF/EOF).
Agora são arquivos reais com syntax highlighting e diff nativo.

| Arquivo | Ferramenta | Destino no Sistema |
|:--|:--|:--|
| `clangd.yaml` | Clangd LSP | `%LOCALAPPDATA%\clangd\config.yaml` |
| `.clang-format` | Clang Format | `%USERPROFILE%\.clang-format` |
| `.prettierrc` | Prettier | `%USERPROFILE%\.prettierrc` |
| `.stylua.toml` | StyLua | `%USERPROFILE%\.stylua.toml` |
