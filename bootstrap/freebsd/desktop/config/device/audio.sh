sudo sh -c '
# Stop on Error
set -e

printf "Iniciando a fusao dos scripts de audio...\n"

# Set Default Audio Unit to 0 (Herdado do Script 2, sobrepondo o 1 do Script 1)
sysctl hw.snd.default_unit=0
if command grep -q "^hw.snd.default_unit=" "/etc/sysctl.conf"; then
	sed -i "" "s/^hw.snd.default_unit=.*/hw.snd.default_unit=0/" "/etc/sysctl.conf"
else
	echo "hw.snd.default_unit=0" >> "/etc/sysctl.conf"
fi

# Maximize Volume Levels (FUSÃO TOTAL: Script 1 + Script 2)
printf "Maximizando mixers...\n"
mixer -f "/dev/mixer0" vol=1.00 pcm=1.00 || true
mixer -f "/dev/mixer0" mic=1.00 || true
mixer -f "/dev/mixer1" rec=1.00 || true
mixer -f "/dev/mixer1" monitor=1.00 || true

# Remap Speaker Pins (Do Script 2)
printf "Aplicando pin patching no device.hints...\n"
HINTS_FILE="/boot/device.hints"
HINT_STRING='\''hint.hdaa.0.nid44.config="as=1 seq=0"'\''

if ! command grep -qF "${HINT_STRING}" "${HINTS_FILE}"; then
	echo "${HINT_STRING}" >> "${HINTS_FILE}"
fi

printf "Feito! Por favor, reinicie a maquina.\n"
'