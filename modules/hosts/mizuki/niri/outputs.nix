{
  flake.modules.homeManager."idkana@mizuki" =
    { ... }:
    {
      wayland.windowManager.niri.settings._children = [
        {
          output = {
            _args = [ "Virtual-1" ];
            transform = "normal";
            mode = "1600x900@60.000";
          };
        }
      ];
    };
}
