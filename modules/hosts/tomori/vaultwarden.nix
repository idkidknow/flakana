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
      port = 8000;
    in
    {
      services.vaultwarden = {
        enable = true;
        dbBackend = "sqlite";
        config = {
          DOMAIN = "http://${domain.vaultwarden}";
          ROCKET_PORT = port;
          SIGNUPS_ALLOWED = false;
        };
        backupDir = "/var/backup/vaultwarden";
      };

      services.nginx.upstreams."vaultwarden" = {
        servers."127.0.0.1:${toString port}" = { };
        extraConfig = ''
          zone vaultwarden 64k;
          keepalive 2;
        '';
      };
      services.nginx.virtualHosts."vaultwarden" = {
        forceSSL = true;
        serverName = domain.vaultwarden;
        sslCertificate = "${cert-path}/fullchain.pem";
        sslCertificateKey = "${cert-path}/key.pem";
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://vaultwarden";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $http_cf_connecting_ip;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
}
