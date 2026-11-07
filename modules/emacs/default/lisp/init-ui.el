;;; init-ui.el --- ui -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(defun idkana--set-frame-font (frame)
  (when (display-graphic-p frame)
    (with-selected-frame frame
      (set-frame-font (font-spec :family "JetBrainsMono Nerd Font" :size 18))
      (dolist (script '(han cjk-misc bopomofo))
        (set-fontset-font
         (frame-parameter nil 'font)
         script
         (font-spec :family "LXGW Neo XiHei" :size 18))))))

(idkana--set-frame-font (selected-frame))
(add-hook 'after-make-frame-functions #'idkana--set-frame-font)

(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  (doom-themes-treemacs-theme "doom-atom")
  :config
  (load-theme 'doom-monokai-pro t)
  (doom-themes-visual-bell-config)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))
(use-package solaire-mode
  :init
  (solaire-global-mode t))

(use-package nerd-icons) ; 图标

(use-package tab-line ; tabs for switching buffer
  :demand t
  :init (global-tab-line-mode t)
  :config (setq tab-line-new-button nil)
  :bind
  ("C-<tab>" . tab-line-switch-to-next-tab)
  ("C-<iso-lefttab>" . tab-line-switch-to-prev-tab))

(use-package dashboard ; 启动界面
  :config
  (dashboard-setup-startup-hook)
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-projects-backend 'projectile)
  (dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name)
  (dashboard-items '((recents . 20) (projects . 10))))

(use-package good-scroll ; 丝滑滚动
  :if (display-graphic-p)
  :init (good-scroll-mode t))

(use-package doom-modeline
  :init (doom-modeline-mode t)
  :config
  (setq doom-modeline-minor-modes t))

(use-package treemacs)
(use-package treemacs-projectile
  :after (treemacs projectile))
(use-package treemacs-magit
  :after (treemacs magit))
(use-package treemacs-nerd-icons
  :after (treemacs nerd-icons)
  :config (treemacs-load-theme "nerd-icons"))

(provide 'init-ui)
;;; init-ui.el ends here
