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

### ################################
### Konsole Shell Profile
### ################################

cat << 'EOF' | tee "${HOME}/.local/share/konsole/Shell.profile" > "/dev/null"
[Appearance]
AntiAliasFonts=true
ColorScheme=Breeze
Font=JetBrainsMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
FontFeatures=liga,calt
UseFontBrailleChararacters=true
UseFontLineChararacters=true
WordMode=false
WordModeAttr=true

[General]
Command=/bin/sh
Environment=SHELL_INIT=1,SHELL_TARGET=/bin/sh
Name=Shell
Parent=FALLBACK/

[Terminal Features]
BlinkingCursorEnabled=true
EOF

### ################################
### Konsole Bash Profile
### ################################

cat << 'EOF' | tee "${HOME}/.local/share/konsole/Bash.profile" > "/dev/null"
[Appearance]
AntiAliasFonts=true
ColorScheme=Breeze
Font=JetBrainsMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
FontFeatures=liga,calt
UseFontBrailleChararacters=true
UseFontLineChararacters=true
WordMode=false
WordModeAttr=true

[General]
Command=/usr/local/bin/bash
Environment=SHELL=/usr/local/bin/bash
Name=Bash
Parent=FALLBACK/

[Terminal Features]
BlinkingCursorEnabled=true
EOF

### ################################
### Konsole Zsh Profile
### ################################

cat << 'EOF' | tee "${HOME}/.local/share/konsole/Zsh.profile" > "/dev/null"
[Appearance]
AntiAliasFonts=true
ColorScheme=Breeze
Font=JetBrainsMono Nerd Font,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1
FontFeatures=liga,calt
UseFontBrailleChararacters=true
UseFontLineChararacters=true
WordMode=false
WordModeAttr=true

[General]
Command=/usr/local/bin/zsh
Environment=SHELL=/usr/local/bin/zsh
Name=Zsh
Parent=FALLBACK/

[Terminal Features]
BlinkingCursorEnabled=true
EOF

### ################################################################################################################################
