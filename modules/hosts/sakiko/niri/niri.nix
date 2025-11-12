{ inputs, ... }:
{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      imports = [ inputs.niri-flake.nixosModules.niri ];
      nixpkgs.overlays = [ inputs.niri-flake.overlays.niri ];
      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };
      systemd.user.services.niri-flake-polkit.enable = false;
      niri-flake.cache.enable = false;
    };

  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, config, ... }:
    {
      imports = [ inputs.niri-flake.homeModules.niri ];

      home.packages = with pkgs; [
        xwayland-satellite
        rofi
        nautilus # https://github.com/YaLTeR/niri/issues/702
      ];

      services.gnome-keyring.enable = true;

      systemd.user.services.polkit-mate-authentication-agent-1 = {
        Unit = {
          Description = "polkit-mate-authentication-agent-1";
          Wants = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

      programs.niri.package = pkgs.niri;
      programs.niri.settings = {
        environment = {
          NIXOS_OZONE_WL = "1";
          QT_FFMPEG_DECODING_HW_DEVICE_TYPES = "cuda";
        };

        binds = with config.lib.niri.actions; {
          "Mod+Shift+Slash".action = show-hotkey-overlay;
          "Mod+D" = {
            action = spawn "rofi" "-show" "drun";
            hotkey-overlay.title = "rofi drun";
          };

          "XF86AudioRaiseVolume" = {
            action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+";
            allow-when-locked = true;
          };
          "XF86AudioLowerVolume" = {
            action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-";
            allow-when-locked = true;
          };
          "XF86AudioMute" = {
            action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
            allow-when-locked = true;
          };
          "XF86AudioMicMute" = {
            action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
            allow-when-locked = true;
          };

          "Super+Tab" = {
            action = toggle-overview;
            repeat = false;
          };
          "Alt+Tab" = {
            action = focus-window-previous;
            repeat = false;
          };

          "Mod+Q".action = close-window;

          "Mod+Left".action = focus-column-left;
          "Mod+Down".action = focus-window-down;
          "Mod+Up".action = focus-window-up;
          "Mod+Right".action = focus-column-right;
          "Mod+Shift+WheelScrollDown".action = focus-column-right;
          "Mod+Shift+WheelScrollUp".action = focus-column-left;
          "Mod+Ctrl+Left".action = move-column-left;
          "Mod+Ctrl+Down".action = move-window-down;
          "Mod+Ctrl+Up".action = move-window-up;
          "Mod+Ctrl+Right".action = move-column-right;
          "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
          "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

          "Mod+Home".action = focus-column-first;
          "Mod+End".action = focus-column-last;
          "Mod+Ctrl+Home".action = move-column-to-first;
          "Mod+Ctrl+End".action = move-column-to-last;

          "Mod+Shift+Left".action = focus-monitor-left;
          "Mod+Shift+Down".action = focus-monitor-down;
          "Mod+Shift+Up".action = focus-monitor-up;
          "Mod+Shift+Right".action = focus-monitor-right;

          "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
          "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
          "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
          "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;

          "Mod+Page_Down".action = focus-workspace-down;
          "Mod+Page_Up".action = focus-workspace-up;
          "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
          "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
          "Mod+Shift+Page_Down".action = move-workspace-down;
          "Mod+Shift+Page_Up".action = move-workspace-up;
          "Mod+WheelScrollDown" = {
            action = focus-workspace-down;
            cooldown-ms = 150;
          };
          "Mod+WheelScrollUp" = {
            action = focus-workspace-up;
            cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollDown" = {
            action = move-column-to-workspace-down;
            cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollUp" = {
            action = move-column-to-workspace-up;
            cooldown-ms = 150;
          };

          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;
          "Mod+W".action = toggle-column-tabbed-display;

          "Mod+R".action = switch-preset-column-width;
          "Mod+Shift+R".action = switch-preset-window-height;
          "Mod+Ctrl+R".action = reset-window-height;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;
          "Mod+Ctrl+F".action = expand-column-to-available-width;
          "Mod+C".action = center-column;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Equal".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-5%";
          "Mod+Shift+Equal".action = set-window-height "+5%";

          "Mod+V".action = toggle-window-floating;
          "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

          "Print".action.screenshot.show-pointer = false;
          "Ctrl+Print".action.screenshot-screen.show-pointer = false;
          "Alt+Print".action.screenshot-window = [ ];

          "Ctrl+Alt+Delete".action = quit;

          "Mod+Escape".action = toggle-keyboard-shortcuts-inhibit;

          "Mod+Shift+P".action = power-off-monitors;
          "Mod+P".action = power-on-monitors;
        };

        hotkey-overlay.skip-at-startup = true;

        debug.honor-xdg-activation-with-invalid-serial = [ ];

        input.keyboard = {
          xkb.layout = "us";
          numlock = true;
        };

        input.touchpad = {
          tap = true;
          dwt = true;
          natural-scroll = true;
          scroll-method = "two-finger";
          scroll-factor = 0.6;
        };

        input.mouse = {
          accel-speed = 0.0;
          accel-profile = "flat";
          scroll-method = "no-scroll";
        };

        outputs."eDP-1" = {
          mode.width = 1920;
          mode.height = 1080;
          mode.refresh = 165.004;
          variable-refresh-rate = "on-demand";
        };

        outputs."DP-1" = {
          mode.width = 1920;
          mode.height = 1080;
          mode.refresh = 165.003;
          focus-at-startup = true;
          position = {
            x = 0;
            y = 0;
          };
          variable-refresh-rate = "on-demand";
        };

        layout = {
          gaps = 12;
          center-focused-column = "never";
          always-center-single-column = true;
          empty-workspace-above-first = true;
        };

        layout.preset-column-widths = [
          { proportion = 1. / 3.; }
          { proportion = 1. / 2.; }
          { proportion = 2. / 3.; }
        ];

        layout.default-column-width = {
          proportion = 2. / 3.;
        };

        layout.focus-ring = {
          width = 4;
          active.color = "#779977";
          inactive.color = "#777777";
          urgent.color = "#AA4477";
        };

        layout.border.enable = false;

        layout.background-color = "transparent";

        screenshot-path = "~/screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        animations = {
          workspace-switch.kind.spring = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
          horizontal-view-movement.kind.spring = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };

        window-rules = [
          {
            geometry-corner-radius = {
              bottom-left = 8.;
              bottom-right = 8.;
              top-left = 8.;
              top-right = 8.;
            };
            clip-to-geometry = true;
          }

          # Open the Firefox picture-in-picture player as floating by default.
          {
            matches = [
              {
                app-id = "firefox$";
                title = "^Picture-in-Picture$";
              }
            ];
            open-floating = true;
          }

          {
            matches = [
              { app-id = "^code$"; }
            ];
            draw-border-with-background = false;
            opacity = 0.9;
          }

          {
            matches = [
              { app-id = "^Emacs$"; }
            ];
            draw-border-with-background = false;
            opacity = 0.95;
          }
        ];

        layer-rules = [
          {
            matches = [ { namespace = "^rofi$"; } ];
            shadow.enable = true;
          }
        ];
      };
    };
}
