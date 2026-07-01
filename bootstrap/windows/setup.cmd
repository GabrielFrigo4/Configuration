@echo off

rem ################################################################################################################################

rem ################################
rem Enable Auto Confirmation
rem ################################

winget settings --enable InstallerHashOverride

rem ################################
rem Install Winget Packages
rem ################################

rem language
winget install LLVM.LLVM
winget install zig.zig
winget install GoLang.Go
winget install PyPy.PyPy.3.9
winget install Python.Python.3.14
winget install OpenJS.NodeJS
winget install DenoLand.Deno
winget install Oven-sh.Bun
rem editor
winget install vim.vim
winget install KDE.Kate
winget install Geany.Geany
winget install zyedidia.micro
winget install Notepad++.Notepad++
winget install ArduinoSA.IDE.stable
winget install ZedIndustries.Zed
winget install VSCodium.VSCodium
winget install Google.Antigravity
winget install Google.AntigravityIDE
rem debugger
winget install dnSpyEx.dnSpy
winget install x64dbg.x64dbg
winget install Hex-Rays.IDA.Free
winget instalL Rizin.Cutter
rem database
winget install dbeaver.dbeaver
rem hardware
winget install Intel.OneAPI.BaseToolkit
winget install KhronosGroup.VulkanSDK
winget install Nvidia.CUDA
rem framework
winget install Love2d.Love2d
rem gnuwin32
winget install GnuWin32.Bison
winget install GnuWin32.Cpio
winget install GnuWin32.DiffUtils
winget install GnuWin32.File
winget install GnuWin32.Flex
winget install GnuWin32.GetText
winget install GnuWin32.Grep
winget install GnuWin32.Gzip
winget install GnuWin32.M4
winget install GnuWin32.Make
winget install GnuWin32.UnZip
winget install GnuWin32.Zip
winget install GnuWin32.FindUtils
winget install GnuWin32.Gperf
winget install GnuWin32.Patch
winget install GnuWin32.Tar
winget install GnuWin32.Tree
winget install GnuWin32.Which
rem terminal
winget install GNU.Wget2
winget install JernejSimoncic.Wget
winget install waterlan.dos2unix
winget install JohnMacFarlane.Pandoc
winget install equalsraf.win32yank
rem security
winget install FireDaemon.OpenSSL
winget install Insecure.Nmap
winget install Insecure.Npcap
winget install GnuPG.Gpg4win
rem internet
winget install OpenVPNTechnologies.OpenVPN
winget install OpenVPNTechnologies.OpenVPNConnect
winget install WiresharkFoundation.Wireshark
winget install WinSCP.WinSCP
winget install PuTTY.PuTTY
rem memory
winget install Rufus.Rufus
winget install balenaEtcher
winget install Ventoy.Ventoy
winget install Piriform.Recuva
winget install RARLab.WinRAR
winget install 7zip.7zip
rem information
winget install CPUID.CPU-Z
winget install TechPowerUp.GPU-Z
winget install nepnep.neofetch-win
winget install JosephFinney.Text-Grab
rem microsoft
winget install Microsoft.err
winget install Microsoft.Git
winget install Microsoft.Edit
winget install Microsoft.PowerShell
winget install Microsoft.VisualStudioCode
winget install Microsoft.VisualStudio.2022.Community
winget install Microsoft.VisualStudio.2022.BuildTools
winget install Microsoft.Sysinternals.TCPView
winget install Microsoft.MSIXPackagingTool
winget install Microsoft.WindowsTerminal
winget install Microsoft.PowerToys
winget install Microsoft.WinDbg
rem github
winget install hickford.git-credential-oauth
winget install GitHub.GitHubDesktop
winget install GitHub.cli
rem shell
winget install nushell
winget install chrisant996.Clink
winget install JanDeDobbeleer.OhMyPosh
winget install MSYS2.MSYS2
rem hyper-v
winget install SoftwareFreedomConservancy.QEMU
winget install Oracle.VirtualBox
rem wsl
winget install Microsoft.WSL.PreRelease
winget install dorssel.usbipd-win
winget install Docker.DockerDesktop
winget install RedHat.Podman
rem office
winget install ONLYOFFICE.DesktopEditors
winget install TheDocumentFoundation.LibreOffice
rem browser
winget install Google.Chrome
winget install Mozilla.Firefox.pt-BR
winget install firefoxpwa
rem tweaker
winget install winaero.tweaker
winget install ArminOsaj.AutoDarkMode
rem math
winget install Scilab.Scilab
rem draw
winget install KDE.Krita
winget install GIMP.GIMP.3
winget install Inkscape.Inkscape
winget install BlenderFoundation.Blender
rem game
winget install Valve.Steam
winget install Discord.Discord
winget install Unity.UnityHub
rem device
winget install Logitech.GHUB
winget install timschneeb.GalaxyBudsClient
winget install OBSProject.OBSStudio

rem ################################
rem Add Pin Winget Packages
rem ################################

rem programming
winget pin add MSYS2.MSYS2
winget pin add Nvidia.CUDA
winget pin add Python.Python.3.14
winget pin add Microsoft.VisualStudio.2022.Community
winget pin add Microsoft.VisualStudio.2022.BuildTools
winget pin add ZedIndustries.Zed

rem software
winget pin add Logitech.GHUB
winget pin add OBSProject.OBSStudio
winget pin add Dell.PeripheralManager
winget pin add Discord.Discord

rem ################################################################################################################################

rem ################################
rem Installing Scoop
rem ################################

pwsh -Command "Invoke-RestMethod get.scoop.sh | Invoke-Expression"
scoop bucket add nonportable
scoop bucket add extras
scoop bucket add main
scoop bucket add nerd-fonts
scoop bucket add java

rem ################################
rem Install Scoop Packages
rem ################################

rem utils
scoop install grex
scoop install pstools
scoop install innounp
scoop install winfetch
scoop install winchecksec
scoop install explorer-suite
scoop install resource-hacker
rem coreutils
scoop install coreutils
scoop install uutils-coreutils
rem binutils
scoop install binutils
rem formatter
scoop install stylua
scoop install gopls
rem java
scoop install openjdk
scoop install oraclejre8
rem editor
scoop install nano
scoop install sed
rem software
scoop install digital
scoop install ghidra
rem media
scoop install ani-cli
scoop install yt-dlp
scoop install mpv
rem internet
scoop install lynx
scoop install ngrok
rem memory
scoop install busybox
rem font
scoop install JetBrainsMono-NF
scoop install JetBrainsMono-NF-Propo
scoop install JetBrainsMono-NF-Mono

rem ################################################################################################################################

rem ################################
rem Installing Choco
rem ################################

powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

rem ################################
rem Enable Auto Confirmation
rem ################################

choco feature enable -n=allowGlobalConfirmation

rem ################################
rem Install Choco Packages
rem ################################

rem debuger
choco install pestudio
choco install cheatengine
rem memory
choco install dmde

rem ################################
rem Disable Auto Confirmation
rem ################################

choco feature disable -n=allowGlobalConfirmation

rem ################################################################################################################################

rem ################################
rem PowerShell
rem ################################

pwsh -Command "Unblock-File -Path '%PROGRAMFILES%\PowerShell\7\profile.ps1'"
pwsh -Command "Unblock-File -Path '%ONEDRIVE%\Documentos\PowerShell\Microsoft.PowerShell_profile.ps1'"
pwsh -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned"

rem ################################################################################################################################

rem ################################
rem Setup Git
rem ################################

del "%USERPROFILE%\.gitconfig"
git config --global credential.helper "!gh auth git-credential"
git config --global user.email "${GIT_EMAIL}"
git config --global user.name "Gabriel Frigo"
git config --global init.defaultBranch "main"
git config --global pull.rebase false
git config --global color.ui auto

gh auth login
gh auth setup-git

rem ################################
rem Clone Git Repository
rem ################################

git clone "https://github.com/GabrielFrigo4/.emacs.d" "%USERPROFILE%\.emacs.d"
git clone "https://github.com/GabrielFrigo4/nvim" "%LOCALAPPDATA%\nvim"
git clone "https://github.com/GabrielFrigo4/vimfiles" "%USERPROFILE%\vimfiles"
git clone "https://github.com/GabrielFrigo4/helix" "%APPDATA%\helix"
git clone "https://github.com/JanDeDobbeleer/oh-my-posh" "%USERPROFILE%\.oh-my-posh"

rem ################################
rem Pull Git Config
rem ################################

cd "%USERPROFILE%\.emacs.d"
git pull
cd "%LOCALAPPDATA%\nvim"
git pull
cd "%USERPROFILE%\vimfiles"
git pull
cd "%APPDATA%\helix"
git pull
cd "%USERPROFILE%\.oh-my-posh"
git pull
cd %USERPROFILE%

rem ################################################################################################################################

rem ################################
rem Config Clangd LSP
rem ################################

rem https://github.com/clangd/clangd
mkdir "%LOCALAPPDATA%\clangd" 2>nul
go install golang.org/x/tools/gopls@latest

rem ################################################################################################################################

rem ################################
rem Install JavaScript Modules
rem ################################

npm install --global prettier@latest
npm install --global firebase-tools@latest
npm install --global localtunnel@latest

rem ################################################################################################################################

rem ################################
rem Update Python PIP
rem ################################

python.exe -m pip install --upgrade pip

rem ################################
rem Install Python Modules
rem ################################

rem standard
pip install setuptools --upgrade
pip install autopep8
pip install mypy
rem win
pip install pywin32
pip install pefile
pip install lief
pip install wmi
rem net
pip install websockets
pip install pystun3
pip install flask
rem binary
pip install ropgadget
pip install pwntools
rem esp32
pip install esptool
rem math
pip install pulp
rem file
pip install pyaml
rem docs
pip install weasyprint

rem ################################
rem Setup Python Modules
rem ################################

mkdir "%LOCALAPPDATA%\Programs\Python\Python314\Scripts" 2>nul

call :ROPgadgetBOF > "%LOCALAPPDATA%\Programs\Python\Python314\Scripts\ROPgadget.cmd"
goto :ROPgadgetEOF
:ROPgadgetBOF
echo @echo off
echo python "%LOCALAPPDATA%\Programs\Python\Python314\Scripts\ROPgadget" %%*
exit /b
:ROPgadgetEOF

rem ################################################################################################################################

rem ################################
rem Setup Reverse Proxy
rem ################################

ngrok config add-authtoken 2w0Qgpn9ThPJkEJrTm6Wypk7e05_7EHzDNHjc4aMbjC2MJHYK

rem ################################################################################################################################

rem ################################
rem Setup PlatformIO
rem ################################

wget https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
python get-platformio.py
del get-platformio.py

rem ################################################################################################################################

rem ################################
rem Install Geany Theme
rem ################################

rem https://www.geany.org/
mkdir "%APPDATA%\geany\colorschemes" 2>nul
curl -o "%APPDATA%\geany\colorschemes\one-dark.conf" "https://raw.githubusercontent.com/geany/geany-themes/master/colorschemes/one-dark.conf"
xcopy "C:\Program Files\Geany\share\themes\Prof-Gnome\gtk-3.0" "%APPDATA%\geany" /E /H /C /I
copy "%APPDATA%\geany\gtk-dark.css" "%APPDATA%\geany\geany.css"

rem ################################
rem Install Vim Autoload
rem ################################

rem https://github.com/junegunn/vim-plug
curl -o "%USERPROFILE%\vimfiles\autoload\plug.vim" "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

rem ################################################################################################################################

rem ################################
rem Installing FASM 1
rem ################################

rem https://flatassembler.net
for /f "tokens=*" %%i in ('curl -sL "https://flatassembler.net/download.php" ^| findstr /r "fasmw[0-9]*\.zip" ^| sed "s/.*fasmw\([0-9]*\)\.zip.*/\1/"') do (
    set "RAW_FASM=%%i"
    goto :fasm1_next
)
:fasm1_next
set "FASM_VER=%RAW_FASM:~0,1%"
set "FASM_VER_MAJOR=%RAW_FASM:~1,2%"
set "FASM_VER_MINOR=%RAW_FASM:~3,2%"
set "FASM_VER_NUMB=%RAW_FASM%"
set "FASM_VER_FULL=%FASM_VER%.%FASM_VER_MAJOR%.%FASM_VER_MINOR%"

wget "https://flatassembler.net/fasmw%FASM_VER_NUMB%.zip"
7z x "fasmw%FASM_VER_NUMB%.zip" -o"C:\Program Files\FASM"
del "fasmw%FASM_VER_NUMB%.zip"

rem ################################
rem Installing FASM G
rem ################################

rem https://flatassembler.net
for /f "tokens=*" %%i in ('curl -sL "https://flatassembler.net/download.php" ^| findstr /r "fasmg\..*\.zip" ^| sed "s/.*fasmg\.\(.*\)\.zip.*/\1/"') do (
    set "FASMG_VER=%%i"
    goto :fasmg_next
)
:fasmg_next
wget "https://flatassembler.net/fasmg.%FASMG_VER%.zip"
7z x "fasmg.%FASMG_VER%.zip" -o"C:\Program Files\FASMG"
del "fasmg.%FASMG_VER%.zip"

rem ################################
rem Installing FASM 2
rem ################################

rem https://flatassembler.net
for /f "tokens=*" %%i in ('curl -sL "https://flatassembler.net/download.php" ^| findstr /r "fasm[0-9]*\.zip" ^| findstr /v "fasmw" ^| sed "s/.*fasm\([0-9]*\)\.zip.*/\1/"') do (
    set "FASM2_VER=%%i"
    goto :fasm2_next
)
:fasm2_next
wget "https://flatassembler.net/fasm%FASM2_VER%.zip"
7z x "fasm%FASM2_VER%.zip" -o"C:\Program Files\FASM2"
del "fasm%FASM2_VER%.zip"

rem ################################
rem Installing FASMARM
rem ################################

rem https://arm.flatassembler.net/
for /f "tokens=*" %%i in ('curl -sL "https://arm.flatassembler.net/" ^| findstr "Version" ^| sed "s/.*Version \([0-9.]*\).*/\1/"') do (
    set "FASMARM_VER=%%i"
    goto :fasmarm_next
)
:fasmarm_next
wget "https://arm.flatassembler.net/FASMARM_win32.ZIP"
7z x "FASMARM_win32.ZIP" -o"C:\Program Files\FASMARM"
del "FASMARM_win32.ZIP"

rem ################################
rem Installing GHIDRA
rem ################################

rem https://ghidra-sre.org/
for /f "tokens=1,2" %%i in ('curl -sL "https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest" ^| findstr "browser_download_url.*ghidra_.*_PUBLIC_.*\.zip" ^| sed "s/.*ghidra_\([0-9.]*\)_PUBLIC_\([0-9]*\)\.zip.*/\1 \2/"') do (
    set "GHIDRA_VER=%%i"
    set "GHIDRA_DATE=%%j"
    goto :ghidra_next
)
:ghidra_next
set "GHIDRA_LINK=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_%GHIDRA_VER%_build/ghidra_%GHIDRA_VER%_PUBLIC_%GHIDRA_DATE%.zip"
wget -O "ghidra.zip" "%GHIDRA_LINK%"
7z x "ghidra.zip" -o"C:\Program Files"
ren "C:\Program Files\ghidra_%GHIDRA_VER%_PUBLIC" "GHIDRA"
del "ghidra.zip"

rem ################################
rem Installing XPEViewer
rem ################################

rem https://github.com/horsicq/XPEViewer
for /f "tokens=*" %%i in ('curl -sI "https://github.com/horsicq/XPEViewer/releases/latest" ^| findstr /i "Location:" ^| sed "s/.*\/\(.*\)/\1/" ^| tr -d "\r"') do set "XPEVIEWER_VER=%%i"
wget "https://github.com/horsicq/XPEViewer/releases/download/%XPEVIEWER_VER%/xpeviewer_win64_portable_%XPEVIEWER_VER%_x64.zip"
7z x "xpeviewer_win64_portable_%XPEVIEWER_VER%_x64.zip" -o"C:\Program Files\XPEViewer"
del "xpeviewer_win64_portable_%XPEVIEWER_VER%_x64.zip"

rem ################################
rem Installing XELFViewer
rem ################################

rem https://github.com/horsicq/XELFViewer
for /f "tokens=*" %%i in ('curl -sI "https://github.com/horsicq/XELFViewer/releases/latest" ^| findstr /i "Location:" ^| sed "s/.*\/\(.*\)/\1/" ^| tr -d "\r"') do set "XELFVIEWER_VER=%%i"
wget "https://github.com/horsicq/XELFViewer/releases/download/%XELFVIEWER_VER%/xelfviewer_win64_portable_%XELFVIEWER_VER%.zip"
7z x "xelfviewer_win64_portable_%XELFVIEWER_VER%.zip" -o"C:\Program Files\XELFViewer"
del "xelfviewer_win64_portable_%XELFVIEWER_VER%.zip"

rem ################################
rem Installing XMachOViewer
rem ################################

rem https://github.com/horsicq/XMachOViewer
for /f "tokens=*" %%i in ('curl -sI "https://github.com/horsicq/XMachOViewer/releases/latest" ^| findstr /i "Location:" ^| sed "s/.*\/\(.*\)/\1/" ^| tr -d "\r"') do set "XMACHOVIEWER_VER=%%i"
wget "https://github.com/horsicq/XMachOViewer/releases/download/%XMACHOVIEWER_VER%/xmachoviewer_win64_portable_%XMACHOVIEWER_VER%.zip"
7z x "xmachoviewer_win64_portable_%XMACHOVIEWER_VER%.zip" -o"C:\Program Files\XMachOViewer"
del "xmachoviewer_win64_portable_%XMACHOVIEWER_VER%.zip"

rem ################################
rem Installing XAPKDetector
rem ################################

rem https://github.com/horsicq/XAPKDetector
for /f "tokens=*" %%i in ('curl -sI "https://github.com/horsicq/XAPKDetector/releases/latest" ^| findstr /i "Location:" ^| sed "s/.*\/\(.*\)/\1/" ^| tr -d "\r"') do set "XAPKDETECTOR_VER=%%i"
wget "https://github.com/horsicq/XAPKDetector/releases/download/%XAPKDETECTOR_VER%/xapkdetector_win64_portable_%XAPKDETECTOR_VER%.zip"
7z x "xapkdetector_win64_portable_%XAPKDETECTOR_VER%.zip" -o"C:\Program Files\XAPKDetector"
del "xapkdetector_win64_portable_%XAPKDETECTOR_VER%.zip"

rem ################################
rem Installing XOpcodeCalc
rem ################################

rem https://github.com/horsicq/XOpcodeCalc
for /f "tokens=*" %%i in ('curl -sI "https://github.com/horsicq/XOpcodeCalc/releases/latest" ^| findstr /i "Location:" ^| sed "s/.*\/\(.*\)/\1/" ^| tr -d "\r"') do set "XOPCODE_VER=%%i"
wget "https://github.com/horsicq/XOpcodeCalc/releases/download/%XOPCODE_VER%/xopcodecalc_win64_portable_%XOPCODE_VER%.zip"
7z x "xopcodecalc_win64_portable_%XOPCODE_VER%.zip" -o"C:\Program Files\XOpCode"
del "xopcodecalc_win64_portable_%XOPCODE_VER%.zip"

rem ################################
rem Installing x64dbg Plugin Manager
rem ################################

rem https://github.com/horsicq/x64dbg-Plugin-Manager
for /f "tokens=*" %%i in ('curl -sI "https://github.com/horsicq/x64dbg-Plugin-Manager/releases/latest" ^| findstr /i "Location:" ^| sed "s/.*\/\(.*\)/\1/" ^| tr -d "\r"') do set "X64DBG_PLUGIN_MANAGER_VER=%%i"
wget "https://github.com/horsicq/x64dbg-Plugin-Manager/releases/download/%X64DBG_PLUGIN_MANAGER_VER%/x64plgmnr_win32_portable_%X64DBG_PLUGIN_MANAGER_VER%.zip"
7z x "x64plgmnr_win32_portable_%X64DBG_PLUGIN_MANAGER_VER%.zip" -o"C:\Program Files\x64dbg-Plugin-Manager"
robocopy "C:\Program Files\x64dbg-Plugin-Manager\x64plgmnr_win32_portable" "C:\Program Files\x64dbg-Plugin-Manager" /E /MOV
rmdir /s "C:\Program Files\x64dbg-Plugin-Manager\x64plgmnr_win32_portable"
del "x64plgmnr_win32_portable_%X64DBG_PLUGIN_MANAGER_VER%.zip"

rem ################################
rem Install x64dbg Modules
rem ################################

x64plgmnrc -U
rem https://github.com/horsicq/stringsx64dbg
x64plgmnrc -i stringsx64dbg
rem https://github.com/horsicq/pex64dbg
x64plgmnrc -i pex64dbg
rem https://github.com/horsicq/nfdx64dbg
x64plgmnrc -i nfdx64dbg

rem ################################################################################################################################

rem ################################
rem Installing TeXworks
rem ################################

rem https://github.com/TeXworks/texworks
for /f "tokens=1,2" %%i in ('curl -sL "https://api.github.com/repos/TeXworks/texworks/releases/latest" ^| findstr "browser_download_url.*TeXworks-win10-" ^| sed "s/.*TeXworks-win10-\([0-9.]*\)-\(.*\)\.zip.*/\1 \2/"') do (
    set "TEXWORKS_VER=%%i"
    set "TEXWORKS_GIT_DATE=%%j"
    goto :texworks_next
)
:texworks_next
wget "https://github.com/TeXworks/texworks/releases/download/release-%TEXWORKS_VER%/TeXworks-win10-%TEXWORKS_VER%-%TEXWORKS_GIT_DATE%.zip"
7z x "TeXworks-win10-%TEXWORKS_VER%-%TEXWORKS_GIT_DATE%.zip" -o"C:\Program Files\TeXworks"
del "TeXworks-win10-%TEXWORKS_VER%-%TEXWORKS_GIT_DATE%.zip"

rem ################################################################################################################################

rem ################################
rem Installing Micro Themes
rem ################################

rem https://draculatheme.com/micro
git clone "https://github.com/dracula/micro.git"
mkdir "%USERPROFILE%\.config\micro\colorschemes" 2>nul
copy "micro\dracula.micro" "%USERPROFILE%\.config\micro\colorschemes\dracula.micro"
rmdir /S micro

call :MicroBOF > "%USERPROFILE%\.config\micro\settings.json"
goto :MicroEOF
:MicroBOF
echo {
echo 	"colorscheme": "dracula"
echo }
exit /b
:MicroEOF
