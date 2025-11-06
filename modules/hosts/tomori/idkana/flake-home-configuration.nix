{
  inputs,
  self,
  config,
  ...
}:
let
  username = "idkana";
  hostname = "tomori";
  module = config.flake.modules.homeManager."${username}@${hostname}";
in
{
  flake.homeConfigurations."${username}@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
    inherit (self.nixosConfigurations.${hostname}) pkgs;
    modules = [ module ];
  };
}
