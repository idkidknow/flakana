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
      port = 3000;
    in
    {
      services.forgejo = {
        enable = true;

        settings = {
          server = {
            DOMAIN = domain.forgejo;
            ROOT_URL = "https://${domain.forgejo}/";
            HTTP_ADDR = "127.0.0.1";
            HTTP_PORT = port;
            DISABLE_SSH = true;
          };

          service = {
            DISABLE_REGISTRATION = true;
            REQUIRE_SIGNIN_VIEW = true;
          };

          session = {
            COOKIE_SECURE = true;
          };

          actions = {
            ENABLED = false;
          };
        };
      };

      environment.systemPackages = [
        config.services.forgejo.package
      ];

      services.nginx.virtualHosts."${domain.forgejo}" = {
        forceSSL = true;
        serverName = domain.forgejo;

        sslCertificate = "${cert-path}/fullchain.pem";
        sslCertificateKey = "${cert-path}/key.pem";

        extraConfig = ''
          merge_slashes off;
        '';

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          proxyWebsockets = true;

          extraConfig = ''
            proxy_set_header Host              $host;
            proxy_set_header X-Real-IP         $remote_addr;
            proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            client_max_body_size 512M;
          '';
        };
      };
    };
}
