{ withSystem, ... }:
{
  flake.modules.nixos."hosts/tomori" =
    { pkgs, ... }:
    {
      services.nginx = {
        enable = true;
        package = withSystem pkgs.stdenv.hostPlatform.system (
          { config, ... }: config.nixpkgsInstances.master.nginxMainline
        );
      };
      users.groups.acme.members = [ "nginx" ];
    };
}
