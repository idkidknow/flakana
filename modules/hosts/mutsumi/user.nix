{
  flake.modules.nixos."hosts/mutsumi" =
    { ... }:
    {
      users.users.idkana = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
    };
}
