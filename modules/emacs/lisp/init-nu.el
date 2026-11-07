;;; init-nu.el --- nushell -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package nushell-ts-mode
  :hook (nushell-ts-mode . lsp))

(provide 'init-nu)
;;; init-nu.el ends here
