{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
      };

      users.users.idkana = {
        extraGroups = [ "podman" ];
      };
    };
}
