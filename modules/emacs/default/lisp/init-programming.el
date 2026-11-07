;;; init-programming.el --- programming -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config
  (require 'smartparens-config)
  :bind
  ("C-M-a" . sp-beginning-of-sexp)
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
  ("M-t" . sp-transpose-sexp))


(use-package apheleia ; 保存时格式化
  :init (add-to-list 'mode-line-collapse-minor-modes 'apheleia-mode)
  :config (apheleia-global-mode t))

(use-package eldoc-box
  :init
  (add-to-list 'mode-line-collapse-minor-modes 'eldoc-box-mouse-mode)
  (add-to-list 'mode-line-collapse-minor-modes 'eldoc-box--mouse-support-mode)
  :hook (prog-mode . eldoc-box-mouse-mode)
  :config
  (setq eldoc-box-cleanup-interval 0))

(use-package indent-bars ; 缩进引导线
  :init (add-to-list 'mode-line-collapse-minor-modes 'indent-bars-mode)
  :hook (prog-mode . indent-bars-mode)
  :custom
  (indent-bars-treesit-support t)
  (indent-bars-treesit-scope '((scala function_definition trait_definition object_definition class_definition val_definition)))
  (indent-bars-treesit-wrap '((scala parameters))))

(use-package highlight-parentheses ; 小括号高亮
  :init (add-to-list 'mode-line-collapse-minor-modes 'highlight-parentheses-mode)
  :hook (prog-mode . highlight-parentheses-mode))

(use-package flycheck
  :hook (prog-mode . flycheck-mode))

(provide 'init-programming)
;;; init-programming.el ends here
