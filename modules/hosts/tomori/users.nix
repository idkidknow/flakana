{
  flake.modules.nixos."hosts/tomori" =
    { pkgs, ... }:
    {
      users.users.idkana = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        shell = pkgs.nushell;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ7q2G+4ZERwCOkI2LKv07NDfPofuYPVFIU2q7tru8y7"
        ];
      };

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ7q2G+4ZERwCOkI2LKv07NDfPofuYPVFIU2q7tru8y7"
      ];
    };
}
