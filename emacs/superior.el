;; ################
;; # Settings
;; ################

;; Initial
(setq initial-major-mode 'fundamental-mode)
(setq initial-scratch-message 'nil)
(require 'uniquify)

;; Server
(require 'server)
(unless (server-running-p) (server-start))

;; Variables
(custom-set-variables
 '(column-number-mode t)
 '(global-display-line-numbers-mode t)
 '(display-line-numbers-type 'relative)
 '(custom-enabled-themes '(misterioso))
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(tool-bar-mode nil)
 '(size-indication-mode t)
 '(display-battery-mode t)
 '(display-time-mode t)
 '(xterm-mouse-mode 1))

;; Set default to UTF-8
(set-default-coding-systems 'utf-8)
(setq-default coding-system-for-read 'utf-8)
(setq-default coding-system-for-write 'utf-8)

;; On OSX, swap Meta and Super
;; For Better Keyboard Ergonomics
(when (eq system-type 'darwin)
 (setq mac-command-modifier 'meta)
 (setq mac-option-modifier 'super))

;; Backspace
(global-set-key (kbd "<backspace>") 'backward-delete-char)
(global-set-key (kbd "S-<backspace>") 'backward-delete-char-untabify)

;; Delete
(global-set-key (kbd "<del>") 'backward-delete-char)
(global-set-key (kbd "S-<del>") 'backward-delete-char-untabify)

;; Quit
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; System
(setq-default make-backup-files nil)
(setq-default visible-bell t)

;; ################
;; # Languages
;; ################

;; Set *font-lock* to Maximun Decoration
(setq-default font-lock-maximum-decoration 't)

;; Set *prog-mode*
(setq-default tab-width 4)
(setq-default indent-tabs-mode t)

;; Set *cc-mode*
(setq-default c-ts-mode-indent-offset tab-width)
(setq-default c-ts-mode-indent-style 'bsd)
(setq-default c-basic-offset tab-width)
(setq-default c-default-style "bsd")

;; Set *ruby-mode*
(setq-default ruby-indent-tabs-mode t)
(setq-default ruby-indent-level tab-width)

;; Set *sgml-mode*
(setq-default sgml-basic-offset tab-width)

;; Set *bash-mode*
(setq-default sh-basic-offset tab-width)

;; Set *perl-mode*
(setq-default cperl-indent-level tab-width)

;; Set *python-mode*
(setq-default python-indent-guess-indent-offset t)
(setq-default python-indent-guess-indent-offset-verbose nil)
(setq-default python-indent-offset tab-width)

;; Set *python-mode*
(defun custom-python-mode-hook ()
  (setq-local tab-width 4)
  (setq-local indent-tabs-mode t)
  (setq-local python-indent-offset tab-width)
  )
(add-hook 'python-mode-hook #'custom-python-mode-hook)

;; Set *prog-mode*
(defun custom-prog-mode-hook ()
  (setq-local tab-width 4)
  (setq-local indent-tabs-mode t)
  )
(add-hook 'prog-mode-hook 'superword-mode)
(add-hook 'prog-mode-hook #'custom-prog-mode-hook)

;; ################
;; # Treesit
;; ################

;; Import *treesit*
(require 'treesit)

;; Set *treesit-font-lock* to Maximun Decoration
(setq-default treesit-font-lock-level 4)

;; Set *treesit-language-source-alist*
(setq-default treesit-language-source-alist
              '(;; BIN
                (c . ("https://github.com/tree-sitter/tree-sitter-c" "master" "src"))
                (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp" "master" "src"))
                (rust . ("https://github.com/tree-sitter/tree-sitter-rust" "master" "src"))
                (go . ("https://github.com/tree-sitter/tree-sitter-go" "master" "src"))
                ;; JIT
                (c-sharp . ("https://github.com/tree-sitter/tree-sitter-c-sharp" "master" "src"))
                (java . ("https://github.com/tree-sitter/tree-sitter-java" "master" "src"))
                ;; VM
                (python . ("https://github.com/tree-sitter/tree-sitter-python" "master" "src"))
                (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby" "master" "src"))
                ;; WEB
                (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "master" "src"))
                (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
                (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
                (css . ("https://github.com/tree-sitter/tree-sitter-css" "master" "src"))
                ;; SHELL
                (bash . ("https://github.com/tree-sitter/tree-sitter-bash" "master" "src"))
                ;; MAKE
                (cmake . ("https://github.com/uyha/tree-sitter-cmake" "master" "src"))
                ;; CONFIG
                (dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile" "main" "src"))
                (gomod . ("https://github.com/camdencheek/tree-sitter-go-mod" "main" "src"))
                ;; DATA
                (json . ("https://github.com/tree-sitter/tree-sitter-json" "master" "src"))
                (toml . ("https://github.com/tree-sitter/tree-sitter-toml" "master" "src"))
                (yaml . ("https://github.com/ikatyang/tree-sitter-yaml" "master" "src"))))

;; Set *major-mode-remap-alist*
(setq-default major-mode-remap-alist
              '(;; BIN
                (c-mode . c-ts-mode)
                (c++-mode . c++-ts-mode)
                (c-or-c++-mode . c-or-c++-ts-mode)
                (rust-mode . rust-ts-mode)
                (zig-mode . zig-ts-mode)
                (go-mode . go-ts-mode)
                ;; JIT
                (csharp-mode . csharp-ts-mode)
                (java-mode . java-ts-mode)
                ;; VM
                (python-mode . python-ts-mode)
                (ruby-mode . ruby-ts-mode)
                ;; WEB
                (js-mode . js-ts-mode)
                (typescript-mode . typescript-ts-mode)
                (tsx-mode . tsx-ts-mode)
                (css-mode . css-ts-mode)
                ;; EMACS
                (emacs-lisp-mode . emacs-lisp-ts-mode)
                ;; SHELL
                (bash-mode . bash-ts-mode)
                ;; MAKE
                (cmake-mode . cmake-ts-mode)
                ;; CONFIG
                (dockerfile-mode . dockerfile-ts-mode)
                ;; DATA
                (json-mode . json-ts-mode)
                (toml-mode . toml-ts-mode)
                (yaml-mode . yaml-ts-mode)))

;; Set *treesit-load-name-override-list*
(setq-default treesit-load-name-override-list '())

;; Def *tree-sitter-setup*
(defun tree-sitter-setup ()
  (interactive)
  (dolist (source treesit-language-source-alist)
    (treesit-install-language-grammar (car source))))
