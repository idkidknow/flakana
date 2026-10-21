{
  inputs,
  config,
  withSystem,
  ...
}:
let
  inherit (config.flake.modules.nixos) common common-desktop;
in
{
  flake.modules.nixos."hosts/sakiko" =
    { config, pkgs, ... }:
    let
      pkgs-master = withSystem pkgs.stdenv.hostPlatform.system (
        { config, ... }: config.nixpkgsInstances.master
      );
    in
    {
      imports = [
        ./_hardware-configuration.nix
        common
        common-desktop
      ];
      system.stateVersion = "25.05";
      networking.hostName = "sakiko";
      time.timeZone = "Asia/Shanghai";
      i18n.defaultLocale = "zh_CN.UTF-8";

      services.userborn.enable = true;

      vaultix.settings = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFBCz34hfUy6AiB79MP0GJC2+ef61kjXqHvvHmFd62Gz";
      };

      flakana = {
        proxy = {
          enable = true;
          daeWanInterfaces = [
            "eno1"
            "wlp4s0"
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        nushell
        nixfmt
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
        # track: https://github.com/NixOS/nixpkgs/pull/576293
        packages.kernel = (pkgs-master.linuxPackagesFor config.boot.kernelPackages.kernel).openrazer;
      };

      hardware.bluetooth.enable = true;

      services.printing = {
        enable = true;
        cups-pdf.enable = true;
      };

      programs.localsend.enable = true;

      services.orca.enable = true;

      services.input-remapper.enable = true;

      environment.variables.EDITOR = "micro";
    };
}
