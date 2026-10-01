{ inputs, ... }:
{
  flake.modules.homeManager.common-desktop =
    { config, lib, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
        {
          # track: https://github.com/noctalia-dev/noctalia/pull/4656
          disabledModules = [ "programs/noctalia" ];
        }
      ];

      config = lib.mkIf config.flakana.niri.enable {
        programs.noctalia = {
          enable = true;

          settings = ./noctalia.toml;
        };

        wayland.windowManager.niri.settings._children = [
          { spawn-at-startup = [ "noctalia" ]; }
          {
            layer-rule = {
              match._props.namespace = "^noctalia-wallpaper";
              place-within-backdrop = true;
            };
          }
        ];
      };
    };
}
