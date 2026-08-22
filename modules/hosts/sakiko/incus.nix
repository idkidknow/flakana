{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      virtualisation.incus = {
        enable = true;
        package = pkgs.incus;
      };

      networking.firewall.trustedInterfaces = [ "incusbr0" ];
      daeLanInterfaces = [ "incusbr0" ];

      users.users.idkana.extraGroups = [ "incus-admin" ];
    };
}
