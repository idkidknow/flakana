{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      wayland.windowManager.niri.settings._children = [
        {
          output = {
            _args = [ "eDP-1" ];
            transform = "normal";
            mode = "1920x1080@165.004000";
            variable-refresh-rate._props.on-demand = true;
            hot-corners.top-right = { };
          };
        }
        {
          output = {
            _args = [ "DP-1" ];
            transform = "normal";
            mode = "2560x1440@300.001000";
            focus-at-startup = { };
            position._props = {
              x = 0;
              y = 0;
            };
            variable-refresh-rate._props.on-demand = true;
            hot-corners.top-left = { };
          };
        }
      ];
    };
}
