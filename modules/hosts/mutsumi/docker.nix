{
  flake.modules.nixos."hosts/mutsumi" =
    { ... }:
    {
      virtualisation.docker.enable = true;
      users.users.idkana.extraGroups = [ "docker" ];
    };
}
