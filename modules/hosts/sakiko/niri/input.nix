{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      programs.niri.settings.input = {
        keyboard = {
          xkb.layout = "us";
          numlock = true;
        };

        touchpad = {
          tap = true;
          dwt = true;
          natural-scroll = true;
          scroll-method = "two-finger";
          scroll-factor = 0.6;
        };

        mouse = {
          accel-speed = 0.0;
          accel-profile = "flat";
          scroll-method = "no-scroll";
        };
      };
    };
}
