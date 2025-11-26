{ inputs, ... }:
let
  priv = inputs.priv;
  inherit (priv) domain;
in
{
  flake.modules.nixos."hosts/tomori" =
    { config, ... }:
    let
      cert-path = config.security.acme.certs."${domain.root}".directory;
    in
    {
      services.nginx.virtualHosts.a = {
        forceSSL = true;
        serverName = domain.static;
        sslCertificate = "${cert-path}/fullchain.pem";
        sslCertificateKey = "${cert-path}/key.pem";
        locations."/" = {
          root = "/srv/static";
          tryFiles = "$uri $uri/ =404";
        };
      };
    };
}
