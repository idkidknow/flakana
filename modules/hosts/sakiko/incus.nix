{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      virtualisation.incus = {
        enable = true;
        package = pkgs.incus;
        bucketSupport = false;
      };

      networking.firewall.trustedInterfaces = [ "incusbr0" ];
      daeLanInterfaces = [ "incusbr0" ];

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
