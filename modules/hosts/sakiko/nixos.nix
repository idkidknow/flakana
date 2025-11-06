{ inputs, config, ... }:
{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      imports = [
        ./_hardware-configuration.nix
        config.flake.modules.nixos.common
        config.flake.modules.nixos.common-desktop
      ];
      system.stateVersion = "25.05";
      networking.hostName = "sakiko";
      time.timeZone = "Asia/Shanghai";
      i18n.defaultLocale = "zh_CN.UTF-8";

      networking.networkmanager.enable = true;

      networking.firewall.enable = true;
      networking.nftables.enable = true;

      services.userborn.enable = true;

      vaultix.settings = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFBCz34hfUy6AiB79MP0GJC2+ef61kjXqHvvHmFd62Gz";
      };

      environment.systemPackages = with pkgs; [
        nushell
        nixfmt-rfc-style
        nixd
        uutils-coreutils-noprefix
        inputs.deploy-rs.packages.x86_64-linux.deploy-rs
        gh
        emacs
      ];

      programs.nix-ld.enable = true;

      hardware.openrazer = {
        enable = true;
        users = [ "idkana" ];
      };

      services.printing = {
        enable = true;
        cups-pdf.enable = true;
      };

      programs.localsend.enable = true;

      programs.adb.enable = true;

      environment.variables.EDITOR = "micro";
    };
}
