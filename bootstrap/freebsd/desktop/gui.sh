#!/bin/sh

### ################################################################################################################################

### ################################
### Setup SDDM
### ################################

sudo chown -R sddm:sddm "/var/lib/sddm"
sudo sysrc sddm_enable="NO"

### ################################
### Setup LY
### ################################

sudo pkg install --yes ly

cat << "EOF" | sudo tee "/usr/local/bin/ly-wrapper" > "/dev/null"
#!/bin/sh
export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
export LANG=pt_BR.UTF-8
exec /usr/local/bin/ly
EOF
sudo chmod +x "/usr/local/bin/ly-wrapper"

if ! grep -q "^Ly:" "/etc/gettytab"; then
	printf "\nLy:\\\n\t:lo=/usr/local/bin/ly-wrapper:\\\n\t:al=root:tc=Pc:\n" | sudo tee -a "/etc/gettytab" > "/dev/null"
fi

sudo sed -i '.bak' -E 's|^[#[:space:]]*ttyv1.*|ttyv1   "/usr/libexec/getty Ly"         xterm   on  secure|' "/etc/ttys"

### ################################
### Setup Xorg
### ################################

cat << "EOF" | tee "${HOME}/.xinitrc" > "/dev/null"
exec ck-launch-session dbus-run-session startplasma-x11
EOF

### ################################################################################################################################

### ################################
### Setup Konsole Profiles
### ################################

mkdir -p "${HOME}/.local/share/konsole"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KONSOLE_DIR="${SCRIPT_DIR}/../../software/terminals/konsole/freebsd"

cp "${KONSOLE_DIR}/Shell.profile" "${HOME}/.local/share/konsole/Shell.profile"
cp "${KONSOLE_DIR}/Bash.profile" "${HOME}/.local/share/konsole/Bash.profile"
cp "${KONSOLE_DIR}/Zsh.profile" "${HOME}/.local/share/konsole/Zsh.profile"

### ################################################################################################################################
