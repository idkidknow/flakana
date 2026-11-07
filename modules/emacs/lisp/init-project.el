;;; init-project.el --- projectile -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package projectile
  :bind-keymap ("C-c p" . projectile-command-map)
  :config (projectile-mode t))
(use-package counsel-projectile
  :after (projectile)
  :config (counsel-projectile-mode t))

(provide 'init-project)
;;; init-project.el ends here
