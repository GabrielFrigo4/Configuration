### ================================================================================================================================

### ================================
### Installing Open Source Fonts
### ================================

### --------------------------------
### Carlito
### --------------------------------
$fonts = @("Carlito-Regular.ttf", "Carlito-Bold.ttf", "Carlito-Italic.ttf", "Carlito-BoldItalic.ttf")
$baseUrl = "https://github.com/google/fonts/raw/main/ofl/carlito/"
foreach ($font in $fonts) {
	Invoke-WebRequest -Uri "$baseUrl$font" -OutFile $font
	Install-Font -Path ".\$font"
	Remove-Item $font
}

### ================================
### Installing NerdFonts
### ================================

### --------------------------------
### RobotoMono NerdFont
### --------------------------------
Install-NerdFont -Name RobotoMono

### --------------------------------
### JetBrainsMono NerdFont
### --------------------------------
Install-NerdFont -Name JetBrainsMono

### ================================
### Installing Roboto Mono
### ================================

### --------------------------------
### RobotoMono Regular
### --------------------------------
wget "https://github.com/google/fonts/raw/main/ofl/robotomono/RobotoMono%5Bwght%5D.ttf" -O "RobotoMono.ttf"
Install-Font -Path ".\RobotoMono.ttf"
rm "RobotoMono.ttf"
### --------------------------------
### RobotoMono Italic
### --------------------------------
wget "https://github.com/google/fonts/raw/main/ofl/robotomono/RobotoMono-Italic%5Bwght%5D.ttf" -O "RobotoMono-Italic.ttf"
Install-Font -Path ".\RobotoMono-Italic.ttf"
rm "RobotoMono-Italic.ttf"

### ================================
### Installing Meslo Nerd Font
### ================================

### --------------------------------
### MesloLGS NF Regular
### --------------------------------
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -O "MesloLGS NF Regular.ttf"
Install-Font -Path ".\MesloLGS NF Regular.ttf"
rm ".\MesloLGS NF Regular.ttf"
### --------------------------------
### MesloLGS NF Bold
### --------------------------------
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" -O "MesloLGS NF Bold.ttf"
Install-Font -Path ".\MesloLGS NF Bold.ttf"
rm "MesloLGS NF Bold.ttf"
### --------------------------------
### MesloLGS NF Italic
### --------------------------------
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" -O "MesloLGS NF Italic.ttf"
Install-Font -Path ".\MesloLGS NF Italic.ttf"
rm "MesloLGS NF Italic.ttf"
### --------------------------------
### MesloLGS NF Bold Italic
### --------------------------------
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" -O "MesloLGS NF Bold Italic.ttf"
Install-Font -Path ".\MesloLGS NF Bold Italic.ttf"
rm "MesloLGS NF Bold Italic.ttf"

### ================================
### Installing Nerd-Fonts-Symbols
### ================================

### --------------------------------
### SymbolsNerdFont Regular
### --------------------------------
wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFont-Regular.ttf" -O "SymbolsNerdFont Regular.ttf"
Install-Font -Path ".\SymbolsNerdFont Regular.ttf"
rm "SymbolsNerdFont Regular.ttf"
### --------------------------------
### SymbolsNerdFont Mono Regular
### --------------------------------
wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf" -O "SymbolsNerdFont Mono Regular.ttf"
Install-Font -Path ".\SymbolsNerdFont Mono Regular.ttf"
rm "SymbolsNerdFont Mono Regular.ttf"

### ================================
### Installing All-The-Icons
### ================================

git clone "https://github.com/domtronn/all-the-icons.el"
Install-Font -Path ".\all-the-icons.el\fonts\all-the-icons.ttf"
Install-Font -Path ".\all-the-icons.el\fonts\file-icons.ttf"
Install-Font -Path ".\all-the-icons.el\fonts\fontawesome.ttf"
Install-Font -Path ".\all-the-icons.el\fonts\material-design-icons.ttf"
Install-Font -Path ".\all-the-icons.el\fonts\octicons.ttf"
Install-Font -Path ".\all-the-icons.el\fonts\weathericons.ttf"
rmdir -r all-the-icons.el

### ================================================================================================================================
