{
  inputs,
  self,
  config,
  ...
}:
let
  module = config.flake.modules.homeManager."idkana@emilia";
in
{
  flake.homeConfigurations."idkana@emilia" = inputs.home-manager.lib.homeManagerConfiguration {
    inherit (self.systemConfigs.emilia.config.nixpkgs) pkgs;
    modules = [ module ];
  };
}
