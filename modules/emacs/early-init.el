;;; early-init.el --- early init -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

;; Cache library lookups across the Nix package directories.
(setq load-path-filter-function #'load-path-filter-cache-directory-files)

;; gc
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'after-init-hook #'(lambda () (setq gc-cons-threshold 800000)))

;; init.el explicitly activates the packages provided by Nix.
(setq package-enable-at-startup nil)

(provide 'early-init)
;;; early-init.el ends here
