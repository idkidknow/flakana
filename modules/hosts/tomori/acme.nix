{ config, ... }:
let
  priv = config.priv;
  domain = priv.domain.root;
in
{
  flake.modules.nixos.nix-secrets-catalog = {
    security.nix-secrets.secrets.acme-env.recipients = [ "tomori" ];
  };

  flake.modules.nixos."hosts/tomori" =
    { config, ... }:
    {
      security.nix-secrets.secrets.acme-env = {
        owner = "acme";
        group = "acme";
      };
      security.acme = {
        acceptTerms = true;
        defaults.email = priv.email;
        certs."${domain}" = {
          dnsProvider = "cloudflare";
          extraDomainNames = [ "*.${domain}" ];
          environmentFile = config.security.nix-secrets.secrets.acme-env.path;
        };
      };
    };
}
