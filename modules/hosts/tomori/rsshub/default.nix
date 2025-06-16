{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.rsshub = pkgs.callPackage ./_package.nix { };
    };

  flake.modules.nixos."hosts/tomori" =
    {
      lib,
      config,
      ...
    }:
    let
      package = inputs.self.packages.x86_64-linux.rsshub;
    in
    {
      environment.systemPackages = [ package ];

      users.users.rsshub = {
        description = "rsshub daemon user";
        group = "rsshub";
        isSystemUser = true;
      };
      users.groups.rsshub = { };

      services.redis.servers.rsshub = {
        enable = true;
        user = "rsshub";
        port = 0;
      };

      systemd.services.rsshub = {
        description = "RSSHub is an open source, easy to use, and extensible RSS feed aggregator.";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "rsshub";
          Group = "rsshub";
          ExecStart = lib.getExe package;
        };
        environment = {
          PORT = "1200";
          CACHE_TYPE = "redis";
          REDIS_URL = "unix://${config.services.redis.servers.rsshub.unixSocket}";
        };
      };
    };
}
