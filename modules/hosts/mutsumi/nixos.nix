{ inputs, config, ... }:
let
  system = "x86_64-linux";
in
{
  hosts.mutsumi.system = system;
  flake.modules.nixos."hosts/mutsumi" =
    { pkgs, ... }:
    {
      imports = [
        config.flake.modules.nixos.common
        inputs.nix-ld.nixosModules.nix-ld
      ];
      system.stateVersion = "24.05";
      networking.hostName = "mutsumi";
      time.timeZone = "Asia/Shanghai";

      services.userborn.enable = true;

      vaultix.settings = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBZh+8bIh8+cR6ajsPDFUTCiGmC+vd8S9N9nioypSoXl";
      };

      programs.nix-ld.dev.enable = true;

      environment.systemPackages = with pkgs; [
        nushell
        nixfmt-rfc-style
        nixd
        uutils-coreutils-noprefix
        inputs.deploy-rs.packages.x86_64-linux.deploy-rs
      ];

      environment.variables.EDITOR = "micro";
    };
}
