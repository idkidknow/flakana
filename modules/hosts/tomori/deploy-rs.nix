{
  self,
  inputs,
  ...
}:
let
  activate = inputs.deploy-rs.lib."x86_64-linux".activate;
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
