{ inputs, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      imports = [ inputs.vicinae.homeManagerModules.default ];

      services.vicinae = {
        enable = true;

        systemd = {
          enable = true;
          autoStart = true;
        };

        settings = {
          close_on_focus_loss = true;
          favicon_service = "twenty";
          pop_to_root_on_close = true;
          font = {
            normal.size = 12;
          };
          keybinding = "emacs";
          keybinds = {
            "toggle-action-panel" = "alt+X";
          };
          search_files_in_root = false;
          theme = {
            dark.name = "catppuccin-mocha";
            dark.icon_theme = "Breeze Dark";
          };
          launcher_window = {
            client_side_decorations.enabled = true;
            opacity = 0.9;
            rounding = 10;
            layer_shell.keyboard_interactivity = "on_demand";
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

      programs.niri.settings.layer-rules = [
        {
          matches = [ { namespace = "^vicinae$"; } ];
          shadow.enable = true;
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
