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
      vaultix.secrets.kavita = {
        file = ../../../secrets/kavita.age;
        mode = "400";
        owner = "kavita";
        group = "kavita";
      };

      services.kavita = {
        enable = true;
        settings = {
          Port = 5000;
        };
        tokenKeyFile = config.vaultix.secrets.kavita.path;
      };

      services.nginx.virtualHosts."${domain.kavita}" = {
        forceSSL = true;
        serverName = domain.kavita;
        sslCertificate = "${cert-path}/fullchain.pem";
        sslCertificateKey = "${cert-path}/key.pem";
        locations."/" = {
          proxyPass = "http://127.0.0.1:5000";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; aio threads;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "Upgrade";
          '';
        };
      };
    };
}
