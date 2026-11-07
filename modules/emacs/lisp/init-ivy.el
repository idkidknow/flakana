;;; init-ivy.el --- ivy, counsel and swiper -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package ivy
  :delight
  :init (ivy-mode t)
  :config
  (setq ivy-use-virtual-buffers t))
(use-package swiper
  :bind
  ("C-s" . swiper-isearch)
  ("C-r" . swiper-isearch-backward))
(use-package counsel
  :delight
  :after (ivy swiper)
  :init (counsel-mode t))

(use-package amx ; 让使用频率能影响ivy项目顺序
  :init (amx-mode t))

(provide 'init-ivy)
;;; init-ivy.el ends here
