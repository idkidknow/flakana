{ inputs, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      imports = [ inputs.vicinae.homeManagerModules.default ];

      services.vicinae = {
        enable = true;
        autoStart = true;

        settings = {
          closeOnFocusLoss = true;
          faviconService = "twenty";
          font = {
            size = 12;
          };
          keybinding = "emacs";
          popToRootOnClose = true;
          rootSearch = {
            searchFiles = false;
          };
          theme = {
            iconTheme = "breeze-dark";
            name = "catppuccin-mocha";
          };
          window = {
            csd = true;
            opacity = 0.9;
            rounding = 10;
          };
        };
      };

      programs.niri.settings.window-rules = [
        {
          matches = [
            { title = "^Vicinae Settings$"; }
          ];
          draw-border-with-background = false;
        }
      ];

      programs.niri.settings.binds = {
        "Alt+Space" = {
          repeat = false;
          action.spawn = [
            "vicinae"
            "toggle"
          ];
        };

        "Mod+S" = {
          repeat = false;
          action.spawn = [
            "vicinae"
            "vicinae://extensions/vicinae/clipboard/history"
          ];
        };

        "Mod+E" = {
          repeat = false;
          action.spawn = [
            "vicinae"
            "vicinae://extensions/vicinae/wm/switch-windows"
          ];
        };
      };
    };
}
