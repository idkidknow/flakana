{
  inputs,
  config,
  withSystem,
  ...
}:
let
  hostname = "tomori";
  module = config.flake.modules.nixos."hosts/${hostname}";
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      module
      {
        nixpkgs.pkgs = withSystem system ({ config, ... }: config.nixpkgsInstances.default);
      }
    ];
    specialArgs = { inherit inputs; }; # for vaultix
  };
}
