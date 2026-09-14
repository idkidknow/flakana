{
  flake.modules.homeManager.common-desktop =
    { config, lib, ... }:
    lib.mkIf config.flakana.niri.enable {
      wayland.windowManager.niri.settings = {
        binds = {
          "Mod+Shift+Slash".show-hotkey-overlay = { };

          "XF86AudioRaiseVolume" = {
            spawn = [
              "wpctl"
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "0.02+"
            ];
            _props.allow-when-locked = true;
          };
          "XF86AudioLowerVolume" = {
            spawn = [
              "wpctl"
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "0.02-"
            ];
            _props.allow-when-locked = true;
          };
          "XF86AudioMute" = {
            spawn = [
              "wpctl"
              "set-mute"
              "@DEFAULT_AUDIO_SINK@"
              "toggle"
            ];
            _props.allow-when-locked = true;
          };
          "XF86AudioMicMute" = {
            spawn = [
              "wpctl"
              "set-mute"
              "@DEFAULT_AUDIO_SOURCE@"
              "toggle"
            ];
            _props.allow-when-locked = true;
          };

          "Super+Tab" = {
            toggle-overview = { };
            _props.repeat = false;
          };

          "Mod+Q".close-window = { };

          "Mod+Left".focus-column-left = { };
          "Mod+Down".focus-window-down = { };
          "Mod+Up".focus-window-up = { };
          "Mod+Right".focus-column-right = { };
          "Mod+Shift+WheelScrollDown".focus-column-right = { };
          "Mod+Shift+WheelScrollUp".focus-column-left = { };
          "Mod+Ctrl+Left".move-column-left = { };
          "Mod+Ctrl+Down".move-window-down = { };
          "Mod+Ctrl+Up".move-window-up = { };
          "Mod+Ctrl+Right".move-column-right = { };
          "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = { };
          "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = { };

          "Mod+Home".focus-column-first = { };
          "Mod+End".focus-column-last = { };
          "Mod+Ctrl+Home".move-column-to-first = { };
          "Mod+Ctrl+End".move-column-to-last = { };

          "Mod+Shift+Left".focus-monitor-left = { };
          "Mod+Shift+Down".focus-monitor-down = { };
          "Mod+Shift+Up".focus-monitor-up = { };
          "Mod+Shift+Right".focus-monitor-right = { };

          "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = { };
          "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = { };
          "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = { };
          "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = { };

          "Mod+Page_Down".focus-workspace-down = { };
          "Mod+Page_Up".focus-workspace-up = { };
          "Mod+Ctrl+Page_Down".move-column-to-workspace-down = { };
          "Mod+Ctrl+Page_Up".move-column-to-workspace-up = { };
          "Mod+Shift+Page_Down".move-workspace-down = { };
          "Mod+Shift+Page_Up".move-workspace-up = { };
          "Mod+WheelScrollDown" = {
            focus-workspace-down = { };
            _props.cooldown-ms = 150;
          };
          "Mod+WheelScrollUp" = {
            focus-workspace-up = { };
            _props.cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollDown" = {
            move-column-to-workspace-down = { };
            _props.cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollUp" = {
            move-column-to-workspace-up = { };
            _props.cooldown-ms = 150;
          };

          "Mod+Comma".consume-window-into-column = { };
          "Mod+Period".expel-window-from-column = { };
          "Mod+W".toggle-column-tabbed-display = { };

          "Mod+R".switch-preset-column-width = { };
          "Mod+Shift+R".switch-preset-window-height = { };
          "Mod+Ctrl+R".reset-window-height = { };
          "Mod+F".maximize-column = { };
          "Mod+Shift+F".fullscreen-window = { };
          "Mod+Ctrl+F".expand-column-to-available-width = { };
          "Mod+C".center-column = { };

          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";
          "Mod+Shift+Minus".set-window-height = "-5%";
          "Mod+Shift+Equal".set-window-height = "+5%";

          "Mod+V".toggle-window-floating = { };
          "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };

          "Print".screenshot._props.show-pointer = false;
          "Ctrl+Print".screenshot-screen._props.show-pointer = false;
          "Alt+Print".screenshot-window = { };

          "Ctrl+Alt+Delete".quit = { };

          "Mod+Escape".toggle-keyboard-shortcuts-inhibit = { };

          "Mod+Shift+P".power-off-monitors = { };
          "Mod+P".power-on-monitors = { };
        };
      };
    };
}
