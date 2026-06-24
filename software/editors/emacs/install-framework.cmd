@echo off

rem ================================
rem Installing Doom Emacs Framework
rem ================================

rem --------------------------------
rem Remove Lixo
rem --------------------------------
rmdir /s /q "%USERPROFILE%\.emacs" 2>nul
rmdir /s /q "%USERPROFILE%\.emacs.d" 2>nul
rmdir /s /q "%USERPROFILE%\.doom.d" 2>nul

rem --------------------------------
rem Setup Doom Emacs
rem --------------------------------
git clone --depth 1 "https://github.com/doomemacs/doomemacs" "%USERPROFILE%\.emacs.d"
mkdir "%USERPROFILE%\.doom.d\snippets" 2>nul
call "%USERPROFILE%\.emacs.d\bin\doom.cmd" install --force

rem --------------------------------
rem Setup Packages
rem --------------------------------
(
echo (package! mermaid-mode^)
echo (package! ob-mermaid^)
) >> "%USERPROFILE%\.doom.d\packages.el"

call "%USERPROFILE%\.emacs.d\bin\doom.cmd" sync

rem --------------------------------
rem Setup init.el
rem --------------------------------
powershell -Command "(Get-Content '%USERPROFILE%\.doom.d\init.el') -replace ';;tree-sitter','tree-sitter' -replace ';;\(cc \+lsp\)','(cc +lsp +tree-sitter)' -replace ';;\(rust \+lsp\)','(rust +lsp +tree-sitter)' -replace ';;python','(python +lsp +tree-sitter)' -replace ';;javascript','(javascript +lsp +tree-sitter)' -replace ';;typescript','(typescript +lsp +tree-sitter)' -replace ';;toml','(toml +lsp +tree-sitter)' -replace ';;sql','(sql +lsp +tree-sitter)' -replace 'sh\s*;','(sh +tree-sitter) ;' | Set-Content '%USERPROFILE%\.doom.d\init.el'"

call "%USERPROFILE%\.emacs.d\bin\doom.cmd" sync

rem --------------------------------
rem Setup config.el
rem --------------------------------
(
echo ;; Configuração de Fonte ^(JetBrains Mono^)
echo (setq doom-font ^(font-spec :family "JetBrainsMonoNL Nerd Font Mono" :size 16 :weight 'medium^)
echo       doom-variable-pitch-font ^(font-spec :family "JetBrainsMonoNL Nerd Font Mono" :size 16^)^)
echo ;; Ativar Cursor Piscante
echo (blink-cursor-mode t^)
echo.
echo ;; Configuração Mermaid
echo (use-package! mermaid-mode
echo   :mode "\\.mermaid\\'"
echo   :mode "\\.mmd\\'"
echo   :config
echo   ^(setq mermaid-mmdc-location "mmdc"^)
echo   ^(setq mermaid-output-format "png"^)^)
echo.
echo (use-package! ob-mermaid
echo   :after org
echo   :config
echo   ^(setq ob-mermaid-cli-path "mmdc"^)^)
) >> "%USERPROFILE%\.doom.d\config.el"

call "%USERPROFILE%\.emacs.d\bin\doom.cmd" sync

rem --------------------------------
rem Update Doom Emacs
rem --------------------------------
call "%USERPROFILE%\.emacs.d\bin\doom.cmd" upgrade
