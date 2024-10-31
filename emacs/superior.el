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
 '(custom-enabled-themes '(tsdh-dark))
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(tool-bar-mode nil)
 '(size-indication-mode t)
 '(display-battery-mode t)
 '(display-time-mode t)
 '(xterm-mouse-mode 1))

;; Set default to UTF-8 and UTF-16-LE
(when (eq system-type 'windows-nt)
 (set-default-coding-systems 'utf-16-le)
 (set-default-coding-systems 'utf-8))

;; On OSX, swap Meta and Super
;; For Better Keyboard Ergonomics
(when (eq system-type 'darwin)
 (setq mac-command-modifier 'meta)
 (setq mac-option-modifier 'super))

;; Default
(setq-default font-lock-maximum-decoration t)
(setq-default make-backup-files nil)
(setq-default visible-bell t)

;; Set Tab-Indent
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
(defun custom-python-mode-hook ()
  (setq tab-width 4)
  (setq indent-tabs-mode t)
  (setq python-indent-offset tab-width)
  )
(add-hook 'python-mode-hook #'custom-python-mode-hook)

;; Set *prog-mode*
(defun custom-prog-mode-hook ()
  (setq tab-width 4)
  (setq indent-tabs-mode t)
  )
(add-hook 'prog-mode-hook 'superword-mode)
(add-hook 'prog-mode-hook #'custom-prog-mode-hook)
