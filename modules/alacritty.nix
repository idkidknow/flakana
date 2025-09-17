{
  flake.modules.homeManager.common-desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.programs.alacritty;
    in
    {
      options = {
        programs.alacritty.niri-flake-settings = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };

          bind = lib.mkOption {
            type = lib.types.str;
            default = "Mod+T";
          };
        };
      };

      config = lib.mkMerge [
        {
          home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

          programs.alacritty = {
            settings = {
              window.decorations = "None";
              window.opacity = 0.9;

              font.normal = {
                family = "JetBrainsMono Nerd Font";
                style = "Regular";
              };

              cursor.style = {
                shape = "Beam";
                blinking = "On";
              };
            };
          };
        }

        (lib.mkIf cfg.niri-flake-settings.enable {
          programs.niri.settings.binds.${cfg.niri-flake-settings.bind} = {
            action.spawn = "alacritty";
            hotkey-overlay.title = "Open a Terminal: alacritty";
          };

          programs.niri.settings.window-rules = [
            {
              matches = [
                { app-id = "^Alacritty$"; }
              ];
              draw-border-with-background = false;
            }
          ];
        })
      ];
    };
}
