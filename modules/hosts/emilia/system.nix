{
  inputs,
  config,
  self,
  ...
}:
{
  flake.modules.systemManager."hosts/emilia" =
    { pkgs, ... }:
    {
      nixpkgs.hostPlatform = "aarch64-linux";

      imports = [
        config.flake.modules.systemManager.common
      ];

      environment.systemPackages = with pkgs; [
        inputs.system-manager.packages.aarch64-linux.default
        nixfmt
        nixd
      ];

      systemd.services = { };

      environment.sessionVariables.NIX_PATH = [
        "nixpkgs=${inputs.nixpkgs}"
        "flakana=${self}"
      ];
    };
}
