{ inputs, ... }:
{
  flake.modules.nixos."hosts/sakiko" =
    { config, ... }:
    {
      vaultix.secrets = {
        nix-access-tokens.file = ../../../secrets/nix-access-tokens.age;
        nix-access-tokens.owner = "idkana";
      };

      nix.access-tokens-file = config.vaultix.secrets.nix-access-tokens.path;

      nix.named-substituters = {
        nix-community.enable = true;
        nix-community.keyOnly = true;
        garnix.enable = true;
        garnix.keyOnly = true;
        nix-on-droid.enable = true;
        nix-on-droid.keyOnly = true;
        numtide.enable = true;
        numtide.keyOnly = true;
        nix-cachyos-kernel.enable = true;
        nix-cachyos-kernel.keyOnly = true;
      };

      nix.settings = {
        netrc-file = "/etc/nix/netrc";
        trusted-users = [
          "root"
          "idkana"
        ];
      };

      imports = [ inputs.selector4nix.nixosModules.selector4nix ];

      services.selector4nix = {
        enable = true;
        configureSubstituter = "prepend";
        enablePersistentCaching = true;
        settings = {
          server.ip = "127.0.0.1";
          server.port = 5496;
          substituters = [
            {
              url = "https://cache.nixos.org";
            }
            {
              url = "https://mirrors.cernet.edu.cn/nix-channels/store";
              priority = 30;
            }
            {
              url = "https://nix-community.cachix.org";
            }
            {
              url = "https://cache.garnix.io";
              storage_url = "https://garnix-cache.com";
            }
            {
              url = "https://nix-on-droid.cachix.org";
            }
            {
              url = "https://cache.numtide.com";
            }
            {
              url = "https://attic.xuyh0120.win/lantian";
            }
          ];
        };
      };
    };
}
