;;; early-init.el --- Fast terminal startup -*- lexical-binding: t -*-
;;; Commentary:
;; Startup ideas: https://github.com/jamescherti/minimal-emacs.d
;; and https://github.com/doomemacs/core/blob/master/early-init.el.
;; Nix supplies the load path and compiled libraries; no package.el scan is needed.
;;; Code:

;; --no-site-file skips Nix's site-start.el, so supply the packaged grammar
;; directory explicitly.  emacs.nix replaces this path at build time.
(defvar treesit-extra-load-path)
(setq treesit-extra-load-path '("@treesitGrammarPath@"))

(setq package-enable-at-startup nil
      site-run-file nil
      inhibit-default-init t
      inhibit-early-default-init t
      load-prefer-newer nil
      inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name
      initial-scratch-message nil
      initial-major-mode 'fundamental-mode
      menu-bar-mode nil)

;; Startup has already recorded --init-directory.  Redirect runtime state now,
;; before Emacs chooses its native-compilation cache, away from the Nix store.
(setq user-emacs-directory
      (file-name-as-directory
       (expand-file-name "emacs-minimal"
                         (or (getenv "XDG_STATE_HOME")
                             (expand-file-name "~/.local/state")))))
(make-directory user-emacs-directory t)

;; Bound startup allocation, then restore normal GC before opening CLI files.
(setq gc-cons-threshold (* 128 1024 1024)
      gc-cons-percentage 0.6)
(defun idkana-minimal--restore-gc ()
  "Restore interactive garbage collection limits after initialization."
  (setq gc-cons-threshold (* 16 1024 1024)
        gc-cons-percentage 0.1))
(add-hook 'after-init-hook #'idkana-minimal--restore-gc)

;; Keep file-name handlers intact: command-line TRAMP and compressed files
;; must work, and deferred packages make suppressing handlers unnecessary.

;;; early-init.el ends here
