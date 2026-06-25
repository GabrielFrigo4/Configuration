### ################################
### SHELL ENVIRONMENT
### ################################

$env.config.buffer_editor = "notepad++";
$env.config.show_banner = false;
$env.HOME = $"($env.USERPROFILE)";

### ################################
### SHELL VARIABLES
### ################################

let Home = $"($env.USERPROFILE)";
let System32 = "C:\\Windows\\System32";
let OneDrive = $"($Home)\\onedrive";
let Desktop = $"($OneDrive)\\Área de Trabalho";
let Documents = $"($OneDrive)\\Documentos" ;
let Images = $"($OneDrive)\\Imagens";
let Workspace = $"($OneDrive)\\Workspace" ;
let Downloads = $"($Home)\\Downloads";
let VIRTUAL_STORE = $"($env.LOCALAPPDATA)\\VirtualStore";
let FASM_STORE = $"($VIRTUAL_STORE)\\Program Files\\FASM";
let FASM2_STORE = $"($VIRTUAL_STORE)\\Program Files\\FASM2";
let FASMG_STORE = $"($VIRTUAL_STORE)\\Program Files\\FASMG";
let FASMARM_STORE = $"($VIRTUAL_STORE)\\Program Files\\FASMARM";

### ################################
### SHELL OH-MY-POSH
### ################################

# "In Nushell"
# oh-my-posh init nu --config $"($Home)/.oh-my-posh/themes/atomic.omp.json" | save -f $"($Home)/.oh-my-posh.nu";
source "~/.oh-my-posh.nu";

### ################################
### WINDOWS FUNCTIONS
### ################################

# Manual FUNCTIONS
def win-man [term: string] {
	start $"https://learn.microsoft.com/en-us/search/?terms=($term)";
};

### ################################
### UNIX FUNCTIONS
### ################################

# Manual FUNCTIONS
def unix-man [section: string, command: string] {
	mut number = $section;
	if (not ('0123456789' | str contains ($section | str substring (-1..)))) {
		$number = $section | str substring (..-2);
	}
	wsl w3m $"https://www.man7.org/linux/man-pages/man($number)/($command).($section).html";
};

### ################################
### SHELL ALIAS
### ################################

# Software ALIAS
alias wh = which;
alias show = start .;
alias brw = lynx -use_mouse=on -nobrowse=on -nopause=on -show_cursor=off;
# Manual ALIAS
alias man = wsl man;
alias wman = win-man;
alias uman = unix-man;
alias mandoc = unix-man;
# Management ALIAS
alias upget = winget upgrade --all;
alias upcho = sudo wt choco upgrade all;
# Goto ALIAS
alias Goto-Home = cd $"($Home)";
alias Goto-OneDrive = cd $"($OneDrive)";
alias Goto-Desktop = cd $"($Desktop)";
alias Goto-Documents = cd $"($Documents)";
alias Goto-Workspace = cd $"($Workspace)";
alias Goto-Images = cd $"($Images)";
alias Goto-Downloads = cd $"($Downloads)";
alias Goto-Virtual-Store = cd $"($VIRTUAL_STORE)";
alias Goto-FASM-Store = cd $"($FASM_STORE)";
alias Goto-Machine = cd $"($System32)";
# Show ALIAS
alias Show-Explorer = explorer.exe .;
alias Show-Home = explorer.exe $"($Home)";
alias Show-OneDrive = explorer.exe $"($OneDrive)";
alias Show-Desktop = explorer.exe $"($Desktop)";
alias Show-Documents = explorer.exe $"($Documents)";
alias Show-Workspace = explorer.exe $"($Workspace)";
alias Show-Images = explorer.exe $"($Images)";
alias Show-Downloads = explorer.exe $"($Downloads)";
alias Show-Virtual-Store = explorer.exe $"($VIRTUAL_STORE)";
alias Show-FASM-Store = explorer.exe $"($FASM_STORE)";
alias Show-Machine = explorer.exe $"($System32)";
# Server ALIAS
alias frigo-server = ssh -i "$Home/.key/ssh-key-frigo-server.key" $"ubuntu@($env.FRIGO_IP)";
alias orbs-server = ssh -i "$Home/.key/ssh-key-orbs-server.key" $"ubuntu@($env.ORBS_IP)";
# Emacs ALIAS
alias ek = taskkill /IM emacs.exe /F;
alias es = runemacs --fg-daemon;
alias ec = emacsclientw --create-frame --alternate-editor "";
alias oe = emacsclientw --create-frame --alternate-editor "" .;
# Code Editors ALIAS
alias oc = code .;
alias ocm = codium .;
alias oz = zed .;
alias on = nvim .;
alias ov = vim .;

### ################################
### SHELL FUNCTIONS
### ################################

# Management FUNCTIONS
def upscp [] { scoop update; scoop update --all };
def upall [] { upget; upscp; upcho };
# Emacs FUNCTIONS
def er [] { ek; es };
# Antigravity FUNCTIONS
def ant [] {
	let app = $"($env.LOCALAPPDATA)\\Programs\\Antigravity\\Antigravity.exe"
	^cmd /c start "" $app
}
def oa [] {
	let app = $"($env.LOCALAPPDATA)\\Programs\\Antigravity\\Antigravity.exe"
	^cmd /c start "" $app "."
}

### ################################
### SHELL CONFIGURATION
### ################################
