{
  flake.modules.nixOnDroid."hosts/uika" =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.supervisord;

      format = pkgs.formats.ini { };

      sock = "/tmp/supervisor.sock";

      conf =
        {
          unix_http_server.file = sock;
          supervisord = {
            logfile = "/tmp/supervisord.log";
            pidfile = "/tmp/supervisord.pid";
          };
          "rpcinterface:supervisor"."supervisor.rpcinterface_factory" =
            "supervisor.rpcinterface:make_main_rpcinterface";
          supervisorctl.serverurl = "unix://${sock}";
        }
        // (
          cfg.programs
          |> lib.mapAttrs' (
            name: value: {
              name = "program:${name}";
              value = value;
            }
          )
        );
    in
    {
      options.supervisord = {
        programs = lib.mkOption {
          type = lib.types.lazyAttrsOf lib.types.attrs;
          default = { };
        };
        package = lib.mkPackageOption pkgs.python313Packages "supervisor" {
          pkgsText = "pkgs.pythonPackages";
        };
      };

      config = {
        environment.packages = [ cfg.package ];

        environment.etc."supervisord.conf".source = format.generate "supervisord.conf" conf;

        build.activationAfter.reloadSupervisord = ''
          if [ -e ${sock} ]; then
            echo "Reloading supervisord"
            $DRY_RUN_CMD ${cfg.package}/bin/supervisorctl update
          fi
        '';
      };
    };
}
