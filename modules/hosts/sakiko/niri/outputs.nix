{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      programs.niri.settings.outputs = {
        "eDP-1" = {
          mode.width = 1920;
          mode.height = 1080;
          mode.refresh = 165.004;
          variable-refresh-rate = "on-demand";
        };

        "DP-1" = {
          mode.width = 2560;
          mode.height = 1440;
          mode.refresh = 300.001;
          focus-at-startup = true;
          position = {
            x = 0;
            y = 0;
          };
          variable-refresh-rate = "on-demand";
        };
      };
    };
}
