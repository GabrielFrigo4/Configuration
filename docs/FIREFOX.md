# 🦊 Firefox — Configurações e Dicas

Este documento centraliza configurações manuais do Firefox que não são provisionáveis automaticamente via script.

## 📋 Clipboard Assíncrono (`dom.events.testing.asyncClipboard`)

Por padrão, o Firefox bloqueia o acesso assíncrono à área de transferência (clipboard) por questões de segurança em determinados contextos. Algumas ferramentas web e aplicações que dependem de `navigator.clipboard.writeText()` ou `navigator.clipboard.readText()` podem falhar silenciosamente por causa disso.

### Como habilitar

1. Abra uma nova aba e acesse: `about:config`
2. Aceite o aviso de risco (clique em "Aceitar o risco e continuar")
3. Na barra de busca, pesquise por: `dom.events.testing.asyncClipboard`
4. Clique no ícone de toggle (⇄) para definir o valor como **`true`**

### O que isso faz

Habilita o suporte completo às APIs assíncronas de clipboard (`Clipboard API`) no Firefox, permitindo que páginas e aplicações web usem:

- `navigator.clipboard.writeText(texto)` — escrever texto no clipboard
- `navigator.clipboard.readText()` — ler texto do clipboard
- `navigator.clipboard.write(data)` — escrever dados arbitrários
- `navigator.clipboard.read()` — ler dados arbitrários

### Quando usar

Ative essa configuração se você utilizar ferramentas web que precisam copiar/colar programaticamente (ex: editores online, dashboards de CI/CD, ferramentas de DevOps via browser, etc.).

> **Nota:** Esta configuração afeta o comportamento global do Firefox. Se estiver testando isoladamente, prefira usar perfis separados.
