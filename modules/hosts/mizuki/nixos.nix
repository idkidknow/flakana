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
      system.stateVersion = "26.05";
      time.timeZone = "Asia/Shanghai";
      i18n.defaultLocale = "zh_CN.UTF-8";

      networking.networkmanager.enable = true;
      networking.hostName = "mizuki";

      vaultix.settings = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlYqrK+cCt/jG4xhHaP6zK/kBnB2bbDxd0ZFJbQtW+Y";
      };

      services.xserver.enable = true;
      services.displayManager.plasma-login-manager.enable = true;
      services.desktopManager.plasma6.enable = true;

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

      environment.variables.EDITOR = "micro";
    };
}
