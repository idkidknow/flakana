{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      virtualisation.incus = {
        enable = true;
        package = pkgs.incus;
      };

      networking.firewall.trustedInterfaces = [ "incusbr0" ];
      flakana.proxy.daeLanInterfaces = [ "incusbr0" ];

      users.users.idkana.extraGroups = [ "incus-admin" ];
    };
}
