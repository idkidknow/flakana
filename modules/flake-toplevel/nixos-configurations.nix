{
  inputs,
  config,
  lib,
  ...
}:
let
  prefix = "hosts/";
in
{
  flake.nixosConfigurations =
    config.flake.modules.nixos or { }
    |> lib.filterAttrs (name: module: lib.hasPrefix prefix name)
    |> lib.mapAttrs' (
      name: module: {
        name = lib.removePrefix prefix name;
        value = lib.nixosSystem {
          modules = [ module ];
          specialArgs = { inherit inputs; }; # for vaultix
        };
      }
    );
}
