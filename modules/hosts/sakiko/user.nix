{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      users.groups.input = { };
      users.users.idkana = {
        isNormalUser = true;
        extraGroups = [ "wheel" "input" ];
        shell = pkgs.nushell;
      };
    };
}
