{ inputs, config, ... }:
let
  system = "x86_64-linux";
in
{
  hosts.sakiko.system = system;
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      imports = [
        ./_hardware-configuration.nix
        config.flake.modules.nixos.common
      ];
      nixpkgs.hostPlatform = system;
      system.stateVersion = "25.05";
      networking.hostName = "sakiko";
      time.timeZone = "Asia/Shanghai";
      i18n.defaultLocale = "zh_CN.UTF-8";

      networking.networkmanager.enable = true;

      services.userborn.enable = true;

      vaultix.settings = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBZh+8bIh8+cR6ajsPDFUTCiGmC+vd8S9N9nioypSoXl";
      };

      environment.systemPackages = with pkgs; [
        nushell
        nixfmt-rfc-style
        nixd
        uutils-coreutils-noprefix
        inputs.deploy-rs.packages.x86_64-linux.deploy-rs
        alacritty
        firefox
        gh
        emacs
        clash-verge-rev
      ];

      environment.variables.EDITOR = "micro";
    };
}
