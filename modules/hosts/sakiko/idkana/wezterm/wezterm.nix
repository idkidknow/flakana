{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      programs.wezterm = {
        enable = true;
      };

      xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;

      programs.niri.settings.binds."Mod+T" = {
        action.spawn = "wezterm";
        hotkey-overlay.title = "Open a Terminal: wezterm";
      };

      programs.niri.settings.window-rules = [
        {
          matches = [
            { app-id = "^org.wezfurlong.wezterm$"; }
          ];
          draw-border-with-background = false;
        }
      ];
    };
}
