{
  self,
  inputs,
  config,
  ...
}:
let
  activate = inputs.deploy-rs.lib.${config.hosts.tomori.system}.activate;
in
{
  flake.deploy.nodes.tomori = {
    hostname = "tomori";
    sshUser = "root";
    profiles.system = {
      user = "root";
      path = activate.nixos self.nixosConfigurations.tomori;
    };
    profiles.idkana = {
      user = "idkana";
      path = activate.home-manager self.homeConfigurations."idkana@tomori";
    };
  };
}
