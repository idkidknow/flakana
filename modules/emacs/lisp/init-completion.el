;;; init-completion.el --- completion -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package company
  :init
  (add-to-list 'mode-line-collapse-minor-modes 'company-mode)
  (global-company-mode t)
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.0)
  (setq company-tooltip-align-annotations t)
  (setq company-selection-wrap-around t))
(use-package company-posframe
  :if (display-graphic-p)
  :after (company)
  :init
  (add-to-list 'mode-line-collapse-minor-modes 'company-posframe-mode)
  (company-posframe-mode t))

(provide 'init-completion)
;;; init-completion.el ends here
