{ inputs, config, ... }:
{
  flake.modules.systemManager."hosts/emilia" =
    { nixosModulesPath, ... }:
    {
      nixpkgs.hostPlatform = "aarch64-linux";

      imports = [
        config.flake.modules.systemManager.common
      ];

      environment.systemPackages = [
        inputs.system-manager.packages.aarch64-linux.default
      ];

      systemd.services = { };
    };
}
