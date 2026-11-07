;;; init-basic.el --- emacs basic -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(defun next-ten-lines ()
  "`next-line * 10."
  (interactive)
  (forward-line 10))
(defun previous-ten-lines ()
  "`previous-line * 10."
  (interactive)
  (forward-line -10))

(defun idkana--comment-line (n)
  "`comment-line N."
  (interactive "P")
  (progn
    (comment-line n)
    (unless (region-active-p) (forward-line -1))))

(use-package emacs
  :init
  (setq custom-file (locate-user-emacs-file "custom.el"))
  (load custom-file 'noerror 'nomessage)
  (global-auto-revert-mode t)
  (global-display-line-numbers-mode t)
  (xterm-mouse-mode t)
  (which-key-mode t)
  (global-hl-line-mode t)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (delete-selection-mode t)
  (keymap-global-unset "C-j")
  (keymap-global-unset "<insert>")
  :bind
  ("M-p" . previous-ten-lines)
  ("M-n" . next-ten-lines)
  ("C-_" . idkana--comment-line)
  ("C-/" . idkana--comment-line)
  ("C-`" . set-mark-command) ; C-@ when -nw
  ("M-o" . other-window)
  :custom
  (indent-tabs-mode nil)
  (inhibit-startup-message t)
  (make-backup-files nil)
  (cursor-type 'bar)
  (minibuffer-follows-selected-frame nil)
  (mark-even-if-inactive nil)
  (scroll-preserve-screen-position t)
  (scroll-conservatively 10)
  (show-trailing-whitespace t))

(use-package which-key
  :init (add-to-list 'mode-line-collapse-minor-modes 'which-key-mode))
(use-package eldoc
  :init (add-to-list 'mode-line-collapse-minor-modes 'eldoc-mode))

(use-package mwim ; C-a C-e 无视缩进和行尾注释
  :bind
  ("C-a" . mwim-beginning-of-code-or-line)
  ("C-e" . mwim-end-of-code-or-line))

(provide 'init-basic)
;;; init-basic.el ends here
