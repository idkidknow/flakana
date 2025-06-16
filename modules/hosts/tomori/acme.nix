{ inputs, ... }:
let
  priv = inputs.priv;
  domain = priv.domain.root;
in
{
  flake.modules.nixos."hosts/tomori" =
    { config, ... }:
    {
      vaultix.secrets.acme-env = {
        file = ../../../secrets/acme-env.age;
        mode = "400";
        owner = "acme";
        group = "acme";
      };
      security.acme = {
        acceptTerms = true;
        defaults.email = priv.email;
        certs."${domain}" = {
          dnsProvider = "cloudflare";
          extraDomainNames = [ "*.${domain}" ];
          environmentFile = "${config.vaultix.secrets.acme-env.path}";
        };
      };
    };
}
