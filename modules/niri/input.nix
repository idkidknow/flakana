{
  flake.modules.homeManager.common-desktop =
    { config, lib, ... }:
    lib.mkIf config.flakana.niri.enable {
      wayland.windowManager.niri.settings.input = {
        keyboard = {
          xkb.layout = "us";
          numlock = true;
        };

        touchpad = {
          tap = { };
          dwt = { };
          natural-scroll = { };
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
