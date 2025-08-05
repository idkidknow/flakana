{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      systemd.services.just-cat-gamepad = {
        description = "My gamepad keeps vibrating if no one is fetching its data and I don't know why.";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.uutils-coreutils-noprefix}/bin/cat /dev/input/js0";
          StandardOutput = "null";
          Restart = "on-failure";
          RestartSec = "3s";
        };
      };
    };
}
