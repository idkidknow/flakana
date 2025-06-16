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
      sock = "/run/searx/searx.sock";
    in
    {
      services.searx = {
        enable = true;
        package = pkgs.searxng;
        redisCreateLocally = true;
        runInUwsgi = true;
        uwsgiConfig = {
          socket = sock;
          chmod-socket = "660";
        };
        settings = {
          server.secret_key = "114514";
        };
      };

      users.users.nginx.extraGroups = [ "searx" ];

      services.nginx.virtualHosts."${domain.searx}" = {
        forceSSL = true;
        serverName = domain.searx;
        sslCertificate = "${cert-path}/fullchain.pem";
        sslCertificateKey = "${cert-path}/key.pem";
        locations."/" = {
          uwsgiPass = "unix://${sock}";
          extraConfig = ''
            include ${config.services.nginx.package}/conf/uwsgi_params;
            uwsgi_param    HTTP_HOST             $host;
            uwsgi_param    HTTP_CONNECTION       $http_connection;

            # see flaskfix.py
            uwsgi_param    HTTP_X_SCHEME         $scheme;
            uwsgi_param    HTTP_X_SCRIPT_NAME    /searxng;

            # see limiter.py
            uwsgi_param    HTTP_X_REAL_IP        $remote_addr;
            uwsgi_param    HTTP_X_FORWARDED_FOR  $proxy_add_x_forwarded_for;
          '';
        };
      };
    };
}
