{
  flake.modules.nixos."hosts/mizuki" =
    { ... }:
    {
      users.users.idkana = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
    };
}
