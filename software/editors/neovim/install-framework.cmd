@echo off

rem ================================
rem Installing LazyVim Framework
rem ================================

rem --------------------------------
rem Remove Lixo
rem --------------------------------
rmdir /s /q "%LOCALAPPDATA%\nvim" 2>nul

rem --------------------------------
rem Setup LazyVim
rem --------------------------------
git clone "https://github.com/LazyVim/starter" "%LOCALAPPDATA%\nvim"
rmdir /s /q "%LOCALAPPDATA%\nvim\.git" 2>nul

rem --------------------------------
rem Setup options.lua
rem --------------------------------
mkdir "%LOCALAPPDATA%\nvim\lua\config" 2>nul
(
echo -- Ativar Cursor Piscante
echo local cursor_gui = vim.api.nvim_get_option_value^("guicursor", {^}^)
echo local cursor_group = vim.api.nvim_create_augroup^('ConfigCursor', { clear = true }^)
echo vim.api.nvim_create_autocmd^({ 'VimEnter', 'VimResume' }, {
echo 	group = cursor_group,
echo 	pattern = '*',
echo 	command = 'set guicursor=' .. cursor_gui .. ',a:blinkwait500-blinkoff500-blinkon500-Cursor/lCursor'
echo }^)
echo vim.api.nvim_create_autocmd^({ 'VimLeave', 'VimSuspend' }, {
echo 	group = cursor_group,
echo 	pattern = '*',
echo 	command = 'set guicursor='
echo }^)
) >> "%LOCALAPPDATA%\nvim\lua\config\options.lua"
