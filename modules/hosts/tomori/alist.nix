{ inputs, self, ... }:
let
  priv = inputs.priv;
  inherit (priv) domain;
in
{
  perSystem =
    { system, ... }:
    {
      packages.openlist = inputs.nixpkgs-master.legacyPackages.${system}.openlist;
    };

  flake.modules.nixos."hosts/tomori" =
    {
      lib,
      config,
      ...
    }:
    let
      package = self.packages.x86_64-linux.openlist;
      wd = "/var/lib/alist";
      cert-path = config.security.acme.certs."${domain.root}".directory;
    in
    {
      environment.systemPackages = [ package ];

      users.users.alist = {
        description = "alist daemon user";
        group = "alist";
        home = wd;
        isSystemUser = true;
      };
      users.groups.alist = { };

      systemd.tmpfiles.settings."10-alist"."${wd}/storage".d = {
        user = "alist";
        group = "alist";
        mode = "700";
      };

      systemd.services.alist = {
        description = "A file list program that supports multiple storage, powered by Gin and Solidjs.";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "alist";
          Group = "alist";
          ExecStart = "${lib.getExe package} server";
          WorkingDirectory = wd;
        };
      };

      services.nginx.virtualHosts."${domain.alist}" = {
        forceSSL = true;
        serverName = domain.alist;
        sslCertificate = "${cert-path}/fullchain.pem";
        sslCertificateKey = "${cert-path}/key.pem";
        locations."/" = {
          proxyPass = "http://127.0.0.1:5244";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $host:$server_port;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Range $http_range;
            proxy_set_header If-Range $http_if_range;
            proxy_redirect off;
            # the max size of file to upload
            client_max_body_size 20000m;
          '';
        };
      };
    };
}
