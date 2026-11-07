;;; init-git.el --- git -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package transient)
(use-package magit)

(use-package diff-hl
  :init (global-diff-hl-mode t)
  :hook (magit-post-refresh diff-hl-magit-post-refresh))

(provide 'init-git)
;;; init-git.el ends here
