# 🚨 ERROS E LIMITAÇÕES DE HARDWARE

Registro de componentes do notebook que atualmente não possuem suporte completo no kernel do FreeBSD.

- [ ] **Caixas de Som Internas (Speaker)**
  - **Componente:** Cirrus Logic 8409.
  - **Motivo:** A placa-mãe possui um mini-amplificador físico (_Smart Amp_) que trava a saída de áudio. O driver `snd_hda` do FreeBSD ainda não possui o código/patch necessário para destravar esse chip específico.
  - **Status:** Congelado. Solução atual é usar fones de ouvido com fio (P2).

- [ ] **Microfone Interno**
  - **Componente:** Cirrus Logic 8409 (Digital).
  - **Motivo:** O sistema reconhece a entrada no canal `pcm1` e permite destravar o volume, porém o driver não consegue interpretar o sinal elétrico de captação de voz desse modelo.
  - **Status:** Congelado. Solução atual é usar o celular para áudio em reuniões ou um Headset/Webcam via USB.

- [ ] **Bluetooth**
  - **Componente:** Controlador Realtek.
  - **Motivo:** O módulo `ng_ubt` não consegue lidar com o gerenciamento de energia desse chip específico, resultando no erro contínuo de `Operation timed out` ao tentar ler o status do rádio local.
  - **Status:** Congelado. Aguardando atualizações futuras na pilha de Bluetooth do sistema operacional.
