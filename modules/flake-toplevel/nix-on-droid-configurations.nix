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
  flake.nixOnDroidConfigurations =
    config.flake.modules.nixOnDroid or { }
    |> lib.filterAttrs (name: module: lib.hasPrefix prefix name)
    |> lib.mapAttrs' (
      name: module: {
        name = lib.removePrefix prefix name;
        value = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages."aarch64-linux";
          modules = [ module ];
        };
      }
    );
}
