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

      programs.niri.settings.spawn-at-startup = [ { argv = [ "noctalia" ]; } ];

      programs.niri.settings.layer-rules = [
        {
          matches = [
            { namespace = "^noctalia-wallpaper"; }
          ];
          place-within-backdrop = true;
        }
      ];

    };
}
