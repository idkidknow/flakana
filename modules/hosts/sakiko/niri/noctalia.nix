{ inputs, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

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
}
