;;; init-treesitter.el --- TS -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(setq treesit-font-lock-level 4)

(use-package treesit-auto
  :custom
  (treesit-auto-install nil) ; Grammars are provided by Nix.
  :config
  (global-treesit-auto-mode t))

(use-package treesit-fold
  :config
  (global-treesit-fold-indicators-mode t)
  :custom
  (treesit-fold-line-count-show t))

(provide 'init-treesitter)
;;; init-treesitter.el ends here
