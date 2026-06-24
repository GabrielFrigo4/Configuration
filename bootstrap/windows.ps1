### ################################################################################################################################

### ################################
### Installing PowerShell Modules
### ################################

Install-Module -Name PSWindowsUpdate
Install-Module -Name Terminal-Icons
Install-Module -Name NerdFonts
Install-Module -Name Fonts
Install-Module -Name pstools

### ################################
### Configure PowerShell
### ################################

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

### ################################################################################################################################

### ################################
### Configure WScript Shell
### ################################

$WshShell = New-Object -ComObject WScript.Shell

### ################################
### Configure Startup
### ################################

$StartupFolder = [Environment]::GetFolderPath('Startup')
$Shortcut = $WshShell.CreateShortcut("$StartupFolder\Emacs-Daemon.lnk")
$Shortcut.TargetPath = "C:\msys64\ucrt64\bin\runemacs.exe"
$Shortcut.Arguments = '--fg-daemon --init-directory "C:\Users\gabri\.emacs.d"'
$Shortcut.Save()

### ################################
### Configure Emacs
### ################################

$TargetFolder = "C:\Users\gabri\AppData\Roaming\Microsoft\Windows\Start Menu\Customizado\Emacs"
if (!(Test-Path -Path $TargetFolder)) {
	New-Item -ItemType Directory -Path $TargetFolder -Force | Out-Null
}

$ShortcutNormal = $WshShell.CreateShortcut("$TargetFolder\Emacs.lnk")
$ShortcutNormal.TargetPath = "C:\msys64\ucrt64\bin\runemacs.exe"
$ShortcutNormal.Arguments = '--init-directory "C:\Users\gabri\.emacs.d"'
$ShortcutNormal.Description = "Inicia uma nova instância standalone do Emacs"
$ShortcutNormal.Save()

$ShortcutClient = $WshShell.CreateShortcut("$TargetFolder\Emacs Client.lnk")
$ShortcutClient.TargetPath = "C:\msys64\ucrt64\bin\emacsclientw.exe"
$ShortcutClient.Arguments = '--server-file "C:\Users\gabri\.emacs.d\var\server\auth\server" --create-frame --alternate-editor "\"C:\msys64\ucrt64\bin\runemacs.exe\" --init-directory \"C:\Users\gabri\.emacs.d\""'
$ShortcutClient.Description = "Conecta ao Emacs Daemon"
$ShortcutClient.Save()

### ################################################################################################################################

### ################################
### Installing Open Source Fonts
### ################################

$fonts = @("Carlito-Regular.ttf", "Carlito-Bold.ttf", "Carlito-Italic.ttf", "Carlito-BoldItalic.ttf")
$baseUrl = "https://github.com/google/fonts/raw/main/ofl/carlito/"
foreach ($font in $fonts) {
	Invoke-WebRequest -Uri "$baseUrl$font" -OutFile $font
	Install-Font -Path ".\$font"
	Remove-Item $font
}

### ################################
### Installing NerdFonts
### ################################

# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/RobotoMono
Install-NerdFont -Name RobotoMono

# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono
Install-NerdFont -Name JetBrainsMono

### ################################
### Installing Roboto Mono
### ################################

# https://github.com/google/fonts/tree/main/ofl/robotomono
# RobotoMono Regular
wget "https://github.com/google/fonts/raw/main/ofl/robotomono/RobotoMono%5Bwght%5D.ttf" -O "RobotoMono.ttf"
Install-Font -Path ".\RobotoMono.ttf"
rm "RobotoMono.ttf"
# RobotoMono Italic
wget "https://github.com/google/fonts/raw/main/ofl/robotomono/RobotoMono-Italic%5Bwght%5D.ttf" -O "RobotoMono-Italic.ttf"
Install-Font -Path ".\RobotoMono-Italic.ttf"
rm "RobotoMono-Italic.ttf"

### ################################
### Installing Meslo Nerd Font
### ################################

# https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k
# MesloLGS NF Regular
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -O "MesloLGS NF Regular.ttf"
Install-Font -Path ".\MesloLGS NF Regular.ttf"
rm ".\MesloLGS NF Regular.ttf"
# MesloLGS NF Bold
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" -O "MesloLGS NF Bold.ttf"
Install-Font -Path ".\MesloLGS NF Bold.ttf"
rm "MesloLGS NF Bold.ttf"
# MesloLGS NF Italic
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" -O "MesloLGS NF Italic.ttf"
Install-Font -Path ".\MesloLGS NF Italic.ttf"
rm "MesloLGS NF Italic.ttf"
# MesloLGS NF Bold Italic
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" -O "MesloLGS NF Bold Italic.ttf"
Install-Font -Path ".\MesloLGS NF Bold Italic.ttf"
rm "MesloLGS NF Bold Italic.ttf"

### ################################
### Installing Nerd-Fonts-Symbols
### ################################

# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/NerdFontsSymbolsOnly
# SymbolsNerdFont Regular
wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFont-Regular.ttf" -O "SymbolsNerdFont Regular.ttf"
Install-Font -Path ".\SymbolsNerdFont Regular.ttf"
rm "SymbolsNerdFont Regular.ttf"
# SymbolsNerdFont Mono Regular
wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf" -O "SymbolsNerdFont Mono Regular.ttf"
Install-Font -Path ".\SymbolsNerdFont Mono Regular.ttf"
rm "SymbolsNerdFont Mono Regular.ttf"

### ################################
### Installing All-The-Icons
### ################################

# https://github.com/domtronn/all-the-icons.el
git clone "https://github.com/domtronn/all-the-icons.el"
Install-Font -Path ".\all-the-icons.el\fonts\all-the-icons.ttf"
Install-Font -Path ".\all-the-icons.el\fonts\file-icons.ttf"
Install-Font -Path ".\all-the-icons.el\fonts\fontawesome.ttf"
Install-Font -Path ".\all-the-icons.el\fonts\material-design-icons.ttf"
Install-Font -Path ".\all-the-icons.el\fonts\octicons.ttf"
Install-Font -Path ".\all-the-icons.el\fonts\weathericons.ttf"
rmdir -r all-the-icons.el

### ################################################################################################################################
