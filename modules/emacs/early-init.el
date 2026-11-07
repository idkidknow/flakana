;;; early-init.el --- early init -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

;; gc
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'after-init-hook #'(lambda () (setq gc-cons-threshold 800000)))

;; init.el explicitly activates the packages provided by Nix.
(setq package-enable-at-startup nil)

(provide 'early-init)
;;; early-init.el ends here
