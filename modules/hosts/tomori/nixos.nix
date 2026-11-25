{ config, ... }:
{
  flake.modules.nixos."hosts/tomori" =
    { pkgs, ... }:
    {
      imports = [
        config.flake.modules.nixos.common
        ./_hardware-configuration.nix
      ];
      system.stateVersion = "24.11";
      networking.hostName = "tomori";
      time.timeZone = "Asia/Tokyo";

      services.userborn.enable = true;

      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "yes";
          PasswordAuthentication = false;
        };
      };

      environment.systemPackages = with pkgs; [
        nushell
        uutils-coreutils-noprefix
        isd
        somo
      ];

      environment.variables.EDITOR = "micro";

      security.doas.enable = true;

      networking.firewall.enable = false;
    };
}
