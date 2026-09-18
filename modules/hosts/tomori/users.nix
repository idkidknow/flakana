{
  flake.modules.nixos."hosts/tomori" =
    { ... }:
    {
      users.users.idkana = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ7q2G+4ZERwCOkI2LKv07NDfPofuYPVFIU2q7tru8y7"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBHx2DAGN1ZSTu3RKdAQWwGoXzI+ijl6JJTO9vH3pdPd"
        ];
      };

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ7q2G+4ZERwCOkI2LKv07NDfPofuYPVFIU2q7tru8y7"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBHx2DAGN1ZSTu3RKdAQWwGoXzI+ijl6JJTO9vH3pdPd"
      ];
    };
}
