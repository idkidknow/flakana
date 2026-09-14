{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      programs.wezterm = {
        enable = true;
      };

      xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;

      wayland.windowManager.niri.settings.binds."Mod+T" = {
        spawn = [ "wezterm" ];
        _props.hotkey-overlay-title = "Open a Terminal: wezterm";
      };

      wayland.windowManager.niri.settings._children = [
        {
          window-rule = {
            match._props.app-id = "^org.wezfurlong.wezterm$";
            draw-border-with-background = false;
          };
        }
      ];
    };
}
