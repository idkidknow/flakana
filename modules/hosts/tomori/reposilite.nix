{ inputs, ... }:
let
  priv = inputs.priv;
  inherit (priv) domain;
in
{
  flake.modules.nixos."hosts/tomori" =
    { pkgs, config, ... }:
    let
      cert-path = config.security.acme.certs."${domain.root}".directory;
      port = 8084;
    in
    {
      services.reposilite = {
        enable = true;
        package = pkgs.reposilite;
        settings = {
          hostname = "127.0.0.1";
          port = port;
        };
        database = {
          type = "sqlite";
          path = "reposilite.db";
        };
      };

      services.nginx.virtualHosts."${domain.reposilite}" = {
        forceSSL = true;
        serverName = domain.reposilite;
        sslCertificate = "${cert-path}/fullchain.pem";
        sslCertificateKey = "${cert-path}/key.pem";
        locations."/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString port}";
          extraConfig = ''
            proxy_set_header Host              $host;
            proxy_set_header X-Real-IP         $remote_addr;
            proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Upgrade           $http_upgrade;
            proxy_set_header Connection        $connection_upgrade;
            proxy_http_version 1.1;
          '';
        };
      };
    };
}
