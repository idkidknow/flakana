;;; init-treesitter.el --- TS -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package treesit
  :custom
  (treesit-font-lock-level 4)
  (treesit-enabled-modes t)
  (treesit-auto-install-grammar 'never)) ; Grammars are provided by Nix.

(use-package hideshow
  :hook (prog-mode . hs-minor-mode)
  :custom
  (hs-show-indicators t)
  (hs-display-lines-hidden t))

(provide 'init-treesitter)
;;; init-treesitter.el ends here
