;;; init-scala.el --- Scala Language -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package scala-ts-mode
  :hook (scala-ts-mode . (lambda () (subword-mode t))))
(use-package lsp-metals
  :hook
  (scala-ts-mode . lsp-deferred)
  :custom
  (lsp-metals-server-args '("-J-Dmetals.allow-multiline-string-formatting=off"
                            "-J-Dmetals.icons=unicode"))
  (lsp-metals-enable-semantic-highlighting t)
  (lsp-metals-inlay-hints-enable-inferred-types t)
  (lsp-metals-inlay-hints-enable-hints-in-pattern-match t))

(provide 'init-scala)
;;; init-scala.el ends here
