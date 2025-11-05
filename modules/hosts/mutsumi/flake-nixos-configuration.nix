{
  inputs,
  config,
  ...
}:
let
  hostname = "mutsumi";
  module = config.flake.modules.nixos."hosts/${hostname}";
in
{
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ module ];
    specialArgs = { inherit inputs; }; # for vaultix
  };
}
