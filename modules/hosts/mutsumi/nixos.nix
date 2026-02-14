{ inputs, config, ... }:
{
  flake.modules.nixos."hosts/mutsumi" =
    { pkgs, ... }:
    {
      imports = [
        config.flake.modules.nixos.common
        inputs.nix-ld.nixosModules.nix-ld
      ];
      system.stateVersion = "25.05";
      networking.hostName = "mutsumi";
      time.timeZone = "Asia/Shanghai";

      services.userborn.enable = true;

      vaultix.settings = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIID/DO+dFUjYAFXyHmaoJTmoAzcdLqt+9miWYeZ32WgD";
      };

      programs.nix-ld.dev.enable = true;

      environment.systemPackages = with pkgs; [
        nushell
        nixfmt
        nixd
        uutils-coreutils-noprefix
        inputs.deploy-rs.packages.x86_64-linux.deploy-rs
      ];

      environment.variables.EDITOR = "micro";
    };
}
