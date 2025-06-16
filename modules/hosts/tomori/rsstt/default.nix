{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.rsstt = pkgs.callPackage ./_package.nix {
        inherit (inputs) uv2nix pyproject-nix pyproject-build-systems;
      };
    };

  flake.modules.nixos."hosts/tomori" =
    { lib, ... }:
    let
      package = inputs.self.packages.x86_64-linux.rsstt;
      wd = "/var/lib/rsstt";
    in
    {
      environment.systemPackages = [ package ];

      users.users.rsstt = {
        description = "rsstt daemon user";
        group = "rsstt";
        isSystemUser = true;
        home = wd;
      };
      users.groups.rsstt = { };

      systemd.tmpfiles.settings."10-rsstt".${wd}.d = {
        user = "rsstt";
        group = "rsstt";
        mode = "700";
      };

      vaultix.secrets.rsstt-dot-env = {
        file = ../../../../secrets/rsstt-dot-env.age;
        mode = "400";
        owner = "rsstt";
        group = "rsstt";
        path = "${wd}/.env";
      };

      systemd.services.rsstt = {
        description = "A Telegram RSS bot that cares about your reading experience";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "rsstt";
          Group = "rsstt";
          ExecStart = "${lib.getExe package} -c ${wd}";
          WorkingDirectory = wd;
        };
      };
    };
}
