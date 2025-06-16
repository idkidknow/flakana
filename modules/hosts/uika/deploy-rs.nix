{
  self,
  inputs,
  ...
}:
let
  activateNixOnDroid =
    configuration:
    inputs.deploy-rs.lib.aarch64-linux.activate.custom configuration.activationPackage "${configuration.activationPackage}/activate";
in
{
  flake.deploy.nodes.uika = {
    hostname = "uika";
    profiles.system = {
      user = "idkana";
      sshUser = "idkana";
      sshOpts = [
        "-p"
        "8022"
      ];
      path = activateNixOnDroid self.nixOnDroidConfigurations.uika;
    };
  };
}
