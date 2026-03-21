{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      networking.firewall.enable = true;
      networking.nftables.enable = true;

      environment.systemPackages = [ pkgs.nixos-firewall-tool ];

      networking.useDHCP = false;

      networking.networkmanager.enable = true;
      users.users.idkana.extraGroups = [ "networkmanager" ];
    };
}
