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

- [ ] **Conexão Wi-Fi**
  - **Componente:** [Ex: Realtek RTL8822CE ou Intel Wi-Fi 6 AX201]
  - **Motivo:** A pilha de rede sem fio nativa do FreeBSD (camada `net80211`) ainda está em processo de modernização. Modelos mais recentes sofrem com a falta de drivers nativos consolidados ou com a incapacidade de utilizar padrões modernos de alta velocidade (como 802.11ac / Wi-Fi 5 e 802.11ax / Wi-Fi 6). Dependendo do chip, o sistema pode não reconhecer a interface `wlan0` de forma alguma, ou limitar a conexão aos padrões legados (802.11a/g/n), causando lentidão.
  - **Status:** [Escolha: Congelado OU Parcialmente Funcional]. Solução atual é utilizar um adaptador Wi-Fi USB compatível (com chipset Ralink ou Atheros), conexão cabeada (Ethernet) ou ancoragem de rede (Tethering) via USB pelo celular.
