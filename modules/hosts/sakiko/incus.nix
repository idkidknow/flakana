{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      virtualisation.incus = {
        enable = true;
      };

      networking.firewall.trustedInterfaces = [ "incusbr0" ];

      users.users.idkana.extraGroups = [ "incus-admin" ];

      # track: https://github.com/nikstur/userborn/issues/7
      environment.etc = {
        "subuid" = {
          text = "root:1000000:1000000000\n";
          mode = "0444";
        };

        "subgid" = {
          text = "root:1000000:1000000000\n";
          mode = "0444";
        };
      };
    };
}
