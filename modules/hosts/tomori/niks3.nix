{ inputs, ... }:
{
  flake.modules.nixos.nix-secrets-catalog = {
    security.nix-secrets.secrets = {
      "niks3/access-key".recipients = [ "tomori" ];
      "niks3/api-token".recipients = [ "tomori" ];
      "niks3/secret-key".recipients = [ "tomori" ];
      "niks3/signing-key".recipients = [ "tomori" ];
    };
  };

  flake.modules.nixos."hosts/tomori" =
    { config, ... }:
    let
      inherit (config.security.nix-secrets) secrets;
      permissions = {
        owner = "niks3";
        group = "niks3";
      };
    in
    {
      imports = [ inputs.niks3.nixosModules.niks3 ];

      security.nix-secrets.secrets = {
        "niks3/access-key" = permissions;
        "niks3/secret-key" = permissions;
        "niks3/api-token" = permissions;
        "niks3/signing-key" = permissions;
      };

      # OIDC discovery needs
      systemd.services.niks3 = {
        wants = [
          "dhcpcd.service"
          "nscd.service"
        ];
        after = [
          "dhcpcd.service"
          "nscd.service"
        ];
      };

      services.niks3 = {
        enable = true;
        httpAddr = "127.0.0.1:5751";

        s3 = {
          endpoint = "329f2f45bd25dd90b302749a61693f30.r2.cloudflarestorage.com";
          bucket = "niks3";
          useSSL = true;
          accessKeyFile = secrets."niks3/access-key".path;
          secretKeyFile = secrets."niks3/secret-key".path;
        };

        apiTokenFile = secrets."niks3/api-token".path;
        signKeyFiles = [ secrets."niks3/signing-key".path ];

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
