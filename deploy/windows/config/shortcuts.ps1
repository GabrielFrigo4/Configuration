### ================================================================================================================================

### ================================
### Configure WScript Shell
### ================================

$WshShell = New-Object -ComObject WScript.Shell

### ================================
### Configure Startup
### ================================

$StartupFolder = [Environment]::GetFolderPath('Startup')
$Shortcut = $WshShell.CreateShortcut("$StartupFolder\Emacs-Daemon.lnk")
$Shortcut.TargetPath = "C:\msys64\ucrt64\bin\runemacs.exe"
$Shortcut.Arguments = '--fg-daemon --init-directory "C:\Users\gabri\.emacs.d"'
$Shortcut.Save()

### ================================
### Configure Emacs
### ================================

$TargetFolder = "C:\Users\gabri\AppData\Roaming\Microsoft\Windows\Start Menu\Customizado\Emacs"
if (!(Test-Path -Path $TargetFolder)) {
	New-Item -ItemType Directory -Path $TargetFolder -Force | Out-Null
}

### --------------------------------
### Emacs Standalone
### --------------------------------
$ShortcutNormal = $WshShell.CreateShortcut("$TargetFolder\Emacs.lnk")
$ShortcutNormal.TargetPath = "C:\msys64\ucrt64\bin\runemacs.exe"
$ShortcutNormal.Arguments = '--init-directory "C:\Users\gabri\.emacs.d"'
$ShortcutNormal.Description = "Inicia uma nova instância standalone do Emacs"
$ShortcutNormal.Save()

### --------------------------------
### Emacs Client
### --------------------------------
$ShortcutClient = $WshShell.CreateShortcut("$TargetFolder\Emacs Client.lnk")
$ShortcutClient.TargetPath = "C:\msys64\ucrt64\bin\emacsclientw.exe"
$ShortcutClient.Arguments = '--server-file "C:\Users\gabri\.emacs.d\var\server\auth\server" --create-frame --alternate-editor "\"C:\msys64\ucrt64\bin\runemacs.exe\" --init-directory \"C:\Users\gabri\.emacs.d\""'
$ShortcutClient.Description = "Conecta ao Emacs Daemon"
$ShortcutClient.Save()

### ================================================================================================================================
