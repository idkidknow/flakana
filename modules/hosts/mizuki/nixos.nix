{ config, ... }:
{
  flake.modules.nixos."hosts/mizuki" =
    { pkgs, ... }:
    {
      imports = [
        ./_hardware-configuration.nix
        config.flake.modules.nixos.common
        config.flake.modules.nixos.common-desktop
      ];

      nixpkgs.config.allowUnfree = true;

      system.stateVersion = "26.05";
      time.timeZone = "Asia/Shanghai";
      i18n.defaultLocale = "zh_CN.UTF-8";

      networking.networkmanager.enable = true;
      networking.hostName = "mizuki";

      vaultix.settings = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlYqrK+cCt/jG4xhHaP6zK/kBnB2bbDxd0ZFJbQtW+Y";
      };

      flakana = {
        proxy.enable = true;
      };

      services.xserver.videoDrivers = [ "vmware" ];
      virtualisation.vmware.guest.enable = true;

      services.userborn.enable = true;

      environment.systemPackages = with pkgs; [
        nushell
        nixfmt
        nixd
        uutils-coreutils-noprefix
        gh
        emacs
        firefox
        fish
        jujutsu
      ];

      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

      programs.nix-ld.enable = true;

      virtualisation.docker.enable = true;

      environment.variables.EDITOR = "micro";
    };
}
