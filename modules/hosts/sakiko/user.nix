{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      users.users.idkana = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        shell = pkgs.nushell;
      };
    };
}
