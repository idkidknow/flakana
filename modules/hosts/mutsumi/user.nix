{
  flake.modules.nixos."hosts/mutsumi" =
    { pkgs, ... }:
    {
      users.users.idkana = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        shell = pkgs.nushell;
      };
    };
}
