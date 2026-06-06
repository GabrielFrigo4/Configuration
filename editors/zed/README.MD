# Zed Configuration (Native Style)
 Configuração otimizada para a experiência nativa do Zed, focada em velocidade, recursos modernos (IA/Predições) e zero emulação de legado.

## 📂 Localização da Configuração
 | Sistema Operacional | Caminho da Pasta |
 | :--- | :--- |
 | **Unix (Linux/macOS)** | `~/.config/zed` |
 | **Windows** | `~\AppData\Roaming\Zed` |

## 🚀 Instalação
 1.  Acesse a pasta de configuração indicada acima.
 2.  Copie o conteúdo do arquivo específico do seu sistema (`unix/settings.json` ou `win/settings.json`) para dentro do arquivo **`settings.json`**.

## ✨ Destaques da Configuração

### 1. Filosofia "Zed Style"
 * **Sem Vim Mode:** O editor funciona como projetado nativamente (atalhos CUA, multi-cursores via mouse/teclado).
 * **Edit Predictions:** Recurso de "previsão de edição" ativado para aumentar a produtividade.
 * **Interface:** Limpa, mas com scrollbar e guias visuais ativas.

### 2. Tratamento de Linguagens
 A configuração deixa o Zed detectar a formatação automaticamente, exceto onde estritamente necessário:
 * **Go & Makefiles:** Força o uso de **Hard Tabs** (requisito técnico dessas ferramentas).
 * **Outras Linguagens:** Usa o padrão visual de 4 espaços (ou o que o arquivo já estiver usando).

### 3. Ferramentas (LSP)
 Configuração explícita para performance máxima em desenvolvimento de sistemas:
 * **C/C++ (Clangd):** Flags de otimização e limpeza (`clang-tidy`) configuradas.
 * **Python (Pyright):** Caminhos absolutos definidos para o interpretador (Linux/Windows).
 * **Rust (Rust-Analyzer):** Check-on-save ativado.
