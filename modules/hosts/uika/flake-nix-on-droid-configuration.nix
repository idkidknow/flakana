{
  inputs,
  config,
  ...
}:
let
  module = config.flake.modules.nixOnDroid."hosts/uika";
in
{
  flake.nixOnDroidConfigurations."uika" = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages."aarch64-linux";
    modules = [ module ];
  };
}
