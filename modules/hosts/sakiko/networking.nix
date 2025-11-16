{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      networking.firewall.enable = true;
      networking.nftables.enable = true;

      networking.useDHCP = false;

      networking.networkmanager.enable = true;
      users.users.idkana.extraGroups = [ "networkmanager" ];
    };
}
