let
  extraPackages = import ./_packages.nix;
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.emacs = pkgs.emacs.pkgs.withPackages extraPackages;
    };

  flake.modules.homeManager.common =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.flakana.emacs.enable = lib.mkEnableOption "My Emacs configuration";

      config = lib.mkIf config.flakana.emacs.enable {
        programs.emacs = {
          enable = true;
          package = pkgs.emacs-pgtk;
          inherit extraPackages;
        };

        home.file = {
          ".emacs.d/early-init.el".source = ./early-init.el;
          ".emacs.d/init.el".source = ./init.el;
          ".emacs.d/lisp" = {
            source = ./lisp;
            recursive = true;
          };
        };
      };
    };
}
