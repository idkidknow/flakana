{
  flake.modules.nixos."hosts/tomori" =
    { pkgs, ... }:
    {
      services.nginx = {
        enable = true;
        package = pkgs.nginxMainline;
      };
      users.groups.acme.members = [ "nginx" ];
    };
}
