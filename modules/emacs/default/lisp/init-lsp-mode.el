;;; init-lsp-mode.el --- lsp-mode -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :commands (lsp lsp-deferred)
  :bind
  ("<f12>" . lsp-find-definition)
  ("C-." . lsp-execute-code-action)
  :custom
  (lsp-inlay-hint-enable t)
  :hook
  (lsp-mode . lsp-inlay-hints-mode)
  (lsp-mode . (lambda () (eldoc-box-mouse-mode -1))))
(use-package lsp-ui ; 鼠标悬停显示信息，还有右侧显示信息
  :after lsp-mode
  :commands lsp-ui-mode
  :custom
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-show-with-mouse t))
(use-package lsp-ivy ; 查workspace里的symbol
  :after (lsp-mode ivy)
  :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs
  :after (lsp-mode treemacs)
  :commands lsp-treemacs-errors-list
  :hook (lsp-mode . lsp-treemacs-sync-mode))

(provide 'init-lsp-mode)
;;; init-lsp-mode.el ends here
