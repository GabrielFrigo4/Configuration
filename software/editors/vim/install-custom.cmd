@echo off

rem ================================
rem Installing Vim Custom
rem ================================

git clone "https://github.com/GabrielFrigo4/vimfiles" "%USERPROFILE%\vimfiles"

rem ================================
rem Configuring Vim Entry Point
rem ================================

(
echo set rtp+=~/vimfiles
echo source ~/vimfiles/vimrc
) > "%USERPROFILE%\_vimrc"
