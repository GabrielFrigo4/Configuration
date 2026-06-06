# Deploy

Scripts de inicialização do sistema.

A filosofia aqui é separar o pesado do leve:
- **`setup.sh` / `setup.cmd`**: Scripts monolíticos que instalam gerenciadores de pacote, pacotes pesados e o core do sistema.
- **`config/`**: Pasta com scripts modulares de configuração que são executados após o setup bruto.
