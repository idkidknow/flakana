{
  inputs,
  self,
  config,
  ...
}:
let
  username = "idkana";
  hostname = "sakiko";
  module = config.flake.modules.homeManager."${username}@${hostname}";
in
{
  flake.homeConfigurations."${username}@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
    inherit (self.nixosConfigurations.${hostname}) pkgs;
    modules = [ module ];
  };
}
