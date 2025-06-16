{ inputs, ... }:
let
  priv = inputs.priv;
  inherit (priv) domain;
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.tieba-cloud-sign = pkgs.callPackage ./_package.nix { };
    };

  flake.modules.nixos."hosts/tomori" =
    {
      pkgs,
      config,
      ...
    }:
    let
      package = inputs.self.packages.x86_64-linux.tieba-cloud-sign;
      user = "tbsign";
      group = "tbsign";
      db-name = "tbsign";
      nginx-user = config.services.nginx.user;
      hostName = domain.tieba-cloud-sign;
      cert-path = config.security.acme.certs."${domain.root}".directory;
      wd = "/var/lib/tieba-cloud-sign";
      pkg = pkgs.stdenvNoCC.mkDerivation {
        pname = "tieba-cloud-sign-${hostName}";
        version = package.version;
        src = package;

        installPhase = ''
          substituteInPlace config.php \
            --replace "'DB_HOST', '127.0.0.1'" "'DB_HOST', 'localhost'" \
            --replace "'DB_USER', 'root'" "'DB_USER', '${user}'" \
            --replace "'DB_NAME', 'tiebacloud'" "'DB_NAME', '${db-name}'"
          substituteInPlace setup/install.php \
            --replace "file_exists(SYSTEM_ROOT2 . '/install.lock')" "file_exists('${wd}/install.lock')"
          substituteInPlace init.php \
            --replace "!file_exists(SYSTEM_ROOT . '/setup/install.lock')" "!file_exists('${wd}/install.lock')"
          mkdir -p $out
          cp -r * $out/
        '';
      };
    in
    {
      environment.systemPackages = [ pkgs.php ];

      users.users.${user} = {
        description = "tieba-cloud-sign daemon user";
        inherit group;
        isSystemUser = true;
        home = wd;
      };
      users.groups.${group} = { };

      systemd.tmpfiles.settings."10-tieba-cloud-sign".${wd}.d = {
        inherit user group;
        mode = "700";
      };

      services.phpfpm.pools.tieba-cloud-sign = {
        inherit user group;
        phpOptions = ''
          max_execution_time = 3600
          upload_max_filesize=128M
          post_max_size=128M
          memory_limit=512M
          date.timezone=Asia/Shanghai
        '';
        settings = {
          "pm" = "ondemand";
          "pm.max_children" = 75;
          "pm.max_requests" = 500;
          "listen.owner" = nginx-user;
          "chdir" = "${pkg}";
        };
      };

      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
      };
      services.mysql.ensureUsers = [
        {
          name = user;
          ensurePermissions = {
            "${db-name}.*" = "ALL PRIVILEGES";
          };
        }
      ];
      services.mysql.ensureDatabases = [ db-name ];

      users.users.${nginx-user}.extraGroups = [ group ];

      services.nginx.virtualHosts.${hostName} = {
        forceSSL = true;
        serverName = hostName;
        sslCertificate = "${cert-path}/fullchain.pem";
        sslCertificateKey = "${cert-path}/key.pem";
        root = "${pkg}";
        extraConfig = ''
          index index.html index.htm index.php;
        '';
        locations."/" = {
          tryFiles = "$uri $uri/ /index.php$is_args$args";
        };
        locations."~ \\.php$" = {
          extraConfig = ''
            fastcgi_pass unix:${config.services.phpfpm.pools.tieba-cloud-sign.socket};
            include ${pkgs.nginx}/conf/fastcgi_params;
            include ${pkgs.nginx}/conf/fastcgi.conf;
          '';
        };
      };

      systemd.services."tieba-cloud-sign" = {
        description = "tieba-cloud-sign do.php";
        serviceConfig = {
          User = user;
          Group = group;
          ExecStart = "${pkgs.php}/bin/php ${pkg}/do.php";
        };
      };
      systemd.timers."tieba-cloud-sign" = {
        timerConfig = {
          OnActiveSec = "1min";
          OnUnitActiveSec = "10min";
          OnCalendar = "*-*-* 00:00:00";
          Unit = "tieba-cloud-sign.service";
        };
        wantedBy = [ "timers.target" ];
      };
    };
}
