;;; init-nix.el --- Nix Language -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(use-package nix-ts-mode
  :hook (nix-ts-mode . lsp-deferred)
  :init
  (add-hook 'lsp-mode-hook (lambda () (lsp-defcustom lsp-nix-nixd-flake-parts-options-expr nil
                                                     "flake-parts options"
                                                     :type 'string
                                                     :group 'lsp-nix-nixd
                                                     :lsp-path "nixd.options.flake-parts.expr")))
  :custom
  (lsp-disabled-clients '((nix-ts-mode . nix-nil)))
  :config
  (setq lsp-nix-nixd-server-path "nixd"
        lsp-nix-nixd-formatting-command ["nixfmt"]
        lsp-nix-nixd-nixpkgs-expr "import <nixpkgs> { }"
        lsp-nix-nixd-nixos-options-expr "(builtins.getFlake \"/home/idkana/flakana\").nixosConfigurations.sakiko.options"
        lsp-nix-nixd-home-manager-options-expr "(builtins.getFlake \"/home/idkana/flakana\").homeConfigurations.\"idkana@sakiko\".options"
        lsp-nix-nixd-flake-parts-options-expr "(builtins.getFlake \"/home/idkana/flakana\").debug.options")
  :mode "\\.nix\\'")

(provide 'init-nix)
;;; init-nix.el ends here
