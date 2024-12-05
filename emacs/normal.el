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

;; Default
(setq-default font-lock-maximum-decoration t)
(setq-default make-backup-files nil)
(setq-default visible-bell t)

;; Backspace
(global-set-key (kbd "<backspace>") 'backward-delete-char)
(global-set-key (kbd "S-<backspace>") 'backward-delete-char-untabify)

;; Delete
(global-set-key (kbd "<del>") 'backward-delete-char)
(global-set-key (kbd "S-<del>") 'backward-delete-char-untabify)

;; Quit
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)