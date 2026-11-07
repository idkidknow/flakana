;;; init.el --- Minimal terminal editing -*- lexical-binding: t -*-
;;; Commentary:
;; Keep editing habits from default, with built-in completion and highlighting.
;; External editing commands are autoloaded, without package-initialize.
;;; Code:

(defvar which-key-idle-delay)

;; early-init.el gives runtime state its own writable directory.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory)
      auto-save-list-file-prefix
      (expand-file-name "auto-save-list/.saves-" user-emacs-directory))

(setq make-backup-files nil
      minibuffer-follows-selected-frame nil
      mark-even-if-inactive nil
      scroll-preserve-screen-position t
      scroll-conservatively 10
      use-short-answers t
      tab-always-indent 'complete
      completion-cycle-threshold 3
      completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      show-paren-delay 0
      which-key-idle-delay 0.5)
(setq-default indent-tabs-mode nil
              show-trailing-whitespace t)

(delete-selection-mode 1)
(xterm-mouse-mode 1)
;; Fido supplies vertical, flex-matching completion for M-x, files and buffers;
;; TAB / M-TAB use the major mode's built-in completion-at-point functions.
(fido-vertical-mode 1)

(defun idkana-minimal--editing-setup ()
  "Enable inexpensive visual aids only in editing buffers."
  (display-line-numbers-mode 1)
  (hl-line-mode 1))
(add-hook 'prog-mode-hook #'idkana-minimal--editing-setup)
(add-hook 'text-mode-hook #'idkana-minimal--editing-setup)
(add-hook 'conf-mode-hook #'idkana-minimal--editing-setup)
(add-hook 'prog-mode-hook #'show-paren-local-mode)

;; These conveniences need not delay the first editable frame.
(run-with-idle-timer 0.5 nil #'which-key-mode 1)
(run-with-idle-timer 0.5 nil #'global-auto-revert-mode 1)

(defun next-ten-lines ()
  "Move forward ten lines."
  (interactive)
  (forward-line 10))
(defun previous-ten-lines ()
  "Move backward ten lines."
  (interactive)
  (forward-line -10))
(defun idkana--comment-line (n)
  "Toggle comments on N lines, keeping the default configuration's movement."
  (interactive "P")
  (comment-line n)
  (unless (region-active-p) (forward-line -1)))

(keymap-global-unset "C-j")
(keymap-global-unset "<insert>")
(keymap-global-set "M-p" #'previous-ten-lines)
(keymap-global-set "M-n" #'next-ten-lines)
(keymap-global-set "C-_" #'idkana--comment-line)
(keymap-global-set "C-/" #'idkana--comment-line)
(keymap-global-set "C-`" #'set-mark-command)
(keymap-global-set "M-o" #'other-window)
(keymap-global-set "C-<tab>" #'next-buffer)
(keymap-global-set "C-<iso-lefttab>" #'previous-buffer)

;; use-package is built into Emacs.  Its declarations compile to autoloads and
;; hooks; none of these packages is required until its command/mode is used.
(eval-when-compile (require 'use-package))
(use-package mwim
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)))
(use-package undo-fu
  :bind (("C-z" . undo-fu-only-undo)
         ("C-S-z" . undo-fu-only-redo)
         ;; Many terminals cannot distinguish C-S-z from C-z.
         ("C-x u" . undo-fu-only-redo)))
(use-package vundo
  :bind ("C-M-z" . vundo))
(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config (require 'smartparens-config)
  :bind (("C-M-a" . sp-beginning-of-sexp)
         ("C-M-e" . sp-end-of-sexp)
         ("C-<down>" . sp-down-sexp)
         ("C-<up>" . sp-up-sexp)
         ("C-<left>" . sp-backward-sexp)
         ("C-<right>" . sp-forward-sexp)
         ("C-M-f" . sp-forward-symbol)
         ("C-M-b" . sp-backward-symbol)
         ("M-<left>" . sp-forward-barf-sexp)
         ("M-<right>" . sp-forward-slurp-sexp)
         ("M-S-<left>" . sp-backward-slurp-sexp)
         ("M-S-<right>" . sp-backward-barf-sexp)
         ("C-M-n" . sp-next-sexp)
         ("C-M-p" . sp-previous-sexp)
         ("M-t" . sp-transpose-sexp)))

;; Tree-sitter modes and parsers load only when visiting a matching file.
;; Nix supplies all grammars; no runtime installation or language servers.
;; Explicit associations also install autoloads without package.el activation.
(use-package treesit
  :defer t
  :init
  (setq treesit-font-lock-level 4
        treesit-auto-install-grammar 'never)
  :custom
  (treesit-enabled-modes t))
(use-package nix-ts-mode
  :mode "\\.nix\\'")
(use-package scala-ts-mode
  :mode "\\.\\(?:scala\\|sc\\|sbt\\|mill\\)\\'"
  :hook (scala-ts-mode . subword-mode))
(use-package rust-ts-mode
  :mode "\\.rs\\'"
  :interpreter "rust-script")
(use-package go-ts-mode
  :mode "\\.go\\'")
(use-package typescript-ts-mode
  :mode "\\.\\(?:ts\\|mts\\|cts\\)\\'"
  :commands tsx-ts-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode)))
(use-package js
  :mode ("\\.\\(?:js\\|mjs\\|cjs\\|jsx\\)\\'" . js-ts-mode))
(use-package lua-ts-mode
  :mode "\\.lua\\'"
  :interpreter "lua")
(use-package yaml-ts-mode
  :mode "\\.ya?ml\\'")
(use-package markdown-ts-mode
  :mode "\\.\\(?:md\\|markdown\\|mdown\\|mkd\\)\\'")
(use-package dockerfile-ts-mode
  :mode (("\\(?:\\`\\|/\\)\\(?:Dockerfile\\|Containerfile\\)\\(?:\\..+\\)?\\'" . dockerfile-ts-mode)
         ("\\.dockerfile\\'" . dockerfile-ts-mode)))
(use-package just-ts-mode
  :mode (("\\(?:\\`\\|/\\)\\.?[Jj]ustfile\\'" . just-ts-mode)
         ("\\.just\\'" . just-ts-mode)))
(use-package toml-ts-mode
  :mode "\\.toml\\'")
(use-package json-ts-mode
  :mode "\\.\\(?:json\\|jsonc\\)\\'")

;;; init.el ends here
