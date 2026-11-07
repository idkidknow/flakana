;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; The Nix wrapper supplies package directories.  Activate their autoloads
;; without reading legacy packages from ~/.emacs.d/elpa.
(require 'package)
(let ((package-user-dir (car package-directory-list)))
  (package-initialize))

(require 'use-package)

(add-to-list
 `load-path (expand-file-name "lisp" user-emacs-directory))

(require 'init-basic)
(require 'init-git)
(require 'init-ivy)
(require 'init-project)
(require 'init-ui)
(require 'init-completion)
(require 'init-programming)
(require 'init-undo)
(require 'init-lsp-mode)
(require 'init-treesitter)
(require 'init-nix)
(require 'init-rust)
(require 'init-just)
(require 'init-nu)
(require 'init-wakatime)
(require 'init-scala)
(require 'init-term)

(provide 'init)
;;; init.el ends here
