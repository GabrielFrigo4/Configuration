@echo off

rem ================================
rem Installing SpaceVim Framework
rem ================================

rem --------------------------------
rem Remove Lixo
rem --------------------------------
rmdir /s /q "%USERPROFILE%\.vim" 2>nul
del /q "%USERPROFILE%\_vimrc" 2>nul
rmdir /s /q "%USERPROFILE%\.SpaceVim" 2>nul
rmdir /s /q "%USERPROFILE%\.SpaceVim.d" 2>nul

rem --------------------------------
rem Setup SpaceVim
rem --------------------------------
git clone "https://github.com/SpaceVim/SpaceVim.git" "%USERPROFILE%\.SpaceVim"
mkdir "%USERPROFILE%\.SpaceVim.d\autoload" 2>nul

rem --------------------------------
rem Setup init.toml
rem --------------------------------
(
echo # =============================================================================
echo # Opções Gerais
echo # =============================================================================
echo [options]
echo    # Define a fonte ^(Importante para GUIs, mas ajuda na detecção de ícones^)
echo    guifont = "JetBrainsMonoNL Nerd Font Mono:h16"
echo.   
echo    # Tema
echo    colorscheme = "onedark"
echo    colorscheme_bg = "dark"
echo.   
echo    # Statusline e Ícones
echo    enable_statusline_mode = true
echo    statusline_separator = "arrow"
echo    enable_tabline_filetype_icon = true
echo    enable_bufferline = true
echo.   
echo    # Aponta para a função de bootstrap ^(onde configuramos o cursor^)
echo    bootstrap_before = "myspacevim#before"
echo.
echo # =============================================================================
echo # Layers ^(Plugins^)
echo # =============================================================================
echo [[layers]]
echo    name = "autocomplete"
echo    auto_completion_return_key_behavior = "complete"
echo    auto_completion_tab_key_behavior = "smart"
echo.
echo [[layers]]
echo    name = "shell"
echo    default_position = "bottom"
echo    default_height = 30
echo.
echo [[layers]]
echo    name = "git"
echo.
echo [[layers]]
echo    name = "lsp"
) > "%USERPROFILE%\.SpaceVim.d\init.toml"

rem --------------------------------
rem Setup myspacevim.vim
rem --------------------------------
(
echo function! myspacevim#before(^) abort
echo    " Ativar Cursor Piscante
echo    let ^^&t_SI = "\e[5 q"
echo    let ^^&t_SR = "\e[3 q"
echo    let ^^&t_EI = "\e[1 q"
echo.   
echo    " Configura o comportamento do cursor para Block/Line
echo    set guicursor+=n-v-c:blinkon1
echo    set guicursor+=i-ci:ver25-blinkon1
echo endfunction
) > "%USERPROFILE%\.SpaceVim.d\autoload\myspacevim.vim"
