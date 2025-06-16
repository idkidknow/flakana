{
  inputs,
  config,
  lib,
  ...
}:
let
  pattern = "[a-z]+@([a-z]+)";
  getHostName =
    name:
    let
      result = lib.match pattern name;
    in
    if result == null then null else lib.head result;
in
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.homeConfigurations =
    config.flake.modules.homeManager or { }
    |> lib.mapAttrs (
      name: module: {
        module = module;
        hostName = getHostName name;
      }
    )
    |> lib.filterAttrs (name: { hostName, ... }: hostName != null)
    |> lib.mapAttrs (
      name:
      { module, hostName }:
      let
        system = config.hosts.${hostName}.system;
      in
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [ module ];
      }
    );
}
