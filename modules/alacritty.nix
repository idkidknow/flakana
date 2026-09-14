{
  flake.modules.homeManager.common-desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
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

          terminal.shell = lib.mkIf (config.programs.fish.enable) "${lib.getExe config.programs.fish.package}";
        };
      };

      wayland.windowManager.niri.settings.binds."Mod+Shift+T" = {
        spawn = [ "alacritty" ];
        _props.hotkey-overlay-title = "Open a Terminal: alacritty";
      };

      wayland.windowManager.niri.settings._children = [
        {
          window-rule = {
            match._props.app-id = "^Alacritty$";
            draw-border-with-background = false;
          };
        }
      ];
    };
}
