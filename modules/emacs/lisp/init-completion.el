;;; init-completion.el --- completion -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package company
  :delight
  :init (global-company-mode t)
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.0)
  (setq company-tooltip-align-annotations t)
  (setq company-selection-wrap-around t))
(use-package company-posframe
  :delight
  :if (display-graphic-p)
  :after (company)
  :init (company-posframe-mode t))

(provide 'init-completion)
;;; init-completion.el ends here
