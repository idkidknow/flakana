{
  flake.modules.homeManager.common =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.nushell;
    in
    {
      options.nushell = {
        isArch = lib.mkOption {
          description = "Arch Linux?";
          type = lib.types.bool;
          default = false;
        };

        isWSL = lib.mkOption {
          description = "WSL?";
          type = lib.types.bool;
          default = false;
        };

        vendorAutoloadDir = lib.mkOption {
          type = lib.types.path;
          default = "${config.xdg.dataHome}/nushell/vendor/autoload";
        };

        configDir = lib.mkOption {
          type = lib.types.path;
          default = "${config.xdg.configHome}/nushell";
        };
      };

      config =
        let
          config-nu-dir = "${cfg.configDir}/config.nu";
          env-nu-dir = "${cfg.configDir}/env.nu";
          options-nu-dir = "${cfg.configDir}/options.nu";
        in
        {
          home.packages = [ pkgs.nushell ];
          home.file.${options-nu-dir}.text = ''
            let $options = {
              is_arch: ${builtins.toJSON cfg.isArch},
              is_wsl: ${builtins.toJSON cfg.isWSL},
            }
          '';
          home.file.${config-nu-dir}.source = ./config.nu;
          home.file.${env-nu-dir}.source = ./env.nu;
        };
    };
}
