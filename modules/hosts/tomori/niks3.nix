{ inputs, ... }:
{
  flake.modules.nixos."hosts/tomori" =
    { config, ... }:
    {
      imports = [ inputs.niks3.nixosModules.niks3 ];

      vaultix.secrets.niks3-access-key = {
        file = ../../../secrets/niks3-access-key.age;
        mode = "400";
        owner = "niks3";
        group = "niks3";
      };
      vaultix.secrets.niks3-secret-key = {
        file = ../../../secrets/niks3-secret-key.age;
        mode = "400";
        owner = "niks3";
        group = "niks3";
      };
      vaultix.secrets.niks3-api-token = {
        file = ../../../secrets/niks3-api-token.age;
        mode = "400";
        owner = "niks3";
        group = "niks3";
      };
      vaultix.secrets.niks3-signing-key = {
        file = ../../../secrets/niks3-signing-key.age;
        mode = "400";
        owner = "niks3";
        group = "niks3";
      };

      services.niks3 = {
        enable = true;
        httpAddr = "127.0.0.1:5751";

        s3 = {
          endpoint = "329f2f45bd25dd90b302749a61693f30.r2.cloudflarestorage.com";
          bucket = "niks3";
          useSSL = true;
          accessKeyFile = config.vaultix.secrets.niks3-access-key.path;
          secretKeyFile = config.vaultix.secrets.niks3-secret-key.path;
        };

        apiTokenFile = config.vaultix.secrets.niks3-api-token.path;
        signKeyFiles = [ config.vaultix.secrets.niks3-signing-key.path ];

        cacheUrl = "https://cache.idkidknow.com";
        serverUrl = "https://niks3.idkidknow.com";

        nginx = {
          enable = true;
          domain = "niks3.idkidknow.com";
        };

        oidc.providers.github = {
          issuer = "https://token.actions.githubusercontent.com";
          audience = "https://niks3.idkidknow.com";
          boundClaims = {
            repository_owner = [ "idkidknow" ];
          };
        };
      };
    };
}
