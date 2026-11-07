;;; init-rust.el --- Rust Language -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

;; (use-package emacs
;;   :hook (rust-ts-mode . lsp-deferred))

(use-package rust-mode
  :init
  (setq rust-mode-treesitter-derive t)
  :hook (rust-mode . lsp-deferred)
  :mode "\\.rs\\'")

(provide 'init-rust)
;;; init-rust.el ends here
