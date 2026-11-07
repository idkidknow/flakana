;;; init-rust.el --- Rust Language -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package rust-ts-mode
  :hook (rust-ts-mode . lsp-deferred)
  :mode "\\.rs\\'")

(provide 'init-rust)
;;; init-rust.el ends here
