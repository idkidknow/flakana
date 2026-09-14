{ inputs, ... }:
{
  flake.modules.homeManager.common-desktop =
    { config, lib, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
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
