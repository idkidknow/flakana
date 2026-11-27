{ config, ... }:
{
  flake.modules.nixos.nix-secrets-catalog = {
    security.nix-secrets.secrets."niks3/api-token".recipients = [ "mizuki" ];
  };

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

      flakana = {
        proxy.enable = true;
        niks3.enable = true;
      };

      services.xserver.videoDrivers = [ "vmware" ];
      virtualisation.vmware.guest.enable = true;
      virtualisation.vmware.guest.headless = false;

      # track (nixos-unstable): https://github.com/NixOS/nixpkgs/pull/581265
      systemd.packages = [
        (pkgs.writeTextDir "lib/systemd/system/run-vmblock\\x2dfuse.mount.d/fuse3.conf" ''
          [Mount]
          Type=fuse3
        '')
      ];

      services.userborn.enable = true;

      environment.systemPackages = with pkgs; [
        nushell
        nixfmt
        nixd
        uutils-coreutils-noprefix
        gh
        firefox
        fish
        jujutsu
      ];

      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

      programs.nix-ld.enable = true;

      virtualisation.docker.enable = true;

      programs.localsend.enable = true;

      services.bootvine.enable = true;

      environment.variables.EDITOR = "micro";
    };
}
