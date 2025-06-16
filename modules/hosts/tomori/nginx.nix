{
  flake.modules.nixos."hosts/tomori" =
    { pkgs, ... }:
    {
      services.nginx = {
        enable = true;
        package = pkgs.nginx;
      };
      users.groups.acme.members = [ "nginx" ];
    };
}
