{ inputs, config, ... }:
let
  inherit (config.flake.modules.nixos) common common-desktop;
in
{
  flake.modules.nixos.nix-secrets-catalog = {
    security.nix-secrets.secrets."niks3/api-token".recipients = [ "sakiko" ];
  };

  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
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

      flakana = {
        niks3.enable = true;
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
      ];

      programs.nix-ld.enable = true;

      hardware.openrazer = {
        enable = true;
        users = [ "idkana" ];
      };

      hardware.bluetooth.enable = true;

      services.printing = {
        enable = true;
        cups-pdf.enable = true;
      };

      programs.localsend.enable = true;

      services.orca.enable = true;

      services.input-remapper.enable = true;

      services.bootvine.enable = true;

      environment.variables.EDITOR = "micro";
    };
}
