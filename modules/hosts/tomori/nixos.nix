{ config, ... }:
let
  system = "x86_64-linux";
in
{
  hosts.tomori.system = system;
  flake.modules.nixos."hosts/tomori" =
    { pkgs, ... }:
    {
      imports = [
        config.flake.modules.nixos.common
        ./_hardware-configuration.nix
      ];
      nixpkgs.hostPlatform = system;
      system.stateVersion = "24.11";
      networking.hostName = "tomori";
      time.timeZone = "Asia/Tokyo";

      services.userborn.enable = true;

      vaultix.settings = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIS7xVMGgnJ7+kBk4wMMhBvF4LXguAE7Iyw5ZqDJWs07";
      };

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
        systemctl-tui
      ];

      environment.variables.EDITOR = "micro";

      security.doas.enable = true;

      networking.firewall.enable = false;
    };
}
