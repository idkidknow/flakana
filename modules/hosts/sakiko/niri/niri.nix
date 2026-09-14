{ ... }:
{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };
    };

  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
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
          ExecStart = "${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

      wayland.windowManager.niri = {
        enable = true;
        package = pkgs.niri;
      };

      wayland.windowManager.niri.settings = {
        hotkey-overlay.skip-at-startup = true;

        binds = {
          "Mod+D" = {
            spawn = [
              "rofi"
              "-show"
              "drun"
            ];
            _props.hotkey-overlay-title = "rofi drun";
          };
        };

        debug.honor-xdg-activation-with-invalid-serial = { };

        layout = {
          gaps = 12;
          center-focused-column = "never";
          always-center-single-column = true;
          empty-workspace-above-first = true;
        };

        layout.preset-column-widths._children = [
          { proportion = 1. / 3.; }
          { proportion = 1. / 2.; }
          { proportion = 2. / 3.; }
        ];

        layout.default-column-width = {
          proportion = 2. / 3.;
        };

        layout.focus-ring = {
          width = 4;
          active-color = "#779977";
          inactive-color = "#777777";
          urgent-color = "#AA4477";
        };

        layout.border.off = { };

        layout.background-color = "transparent";

        screenshot-path = "~/screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        animations = {
          workspace-switch.spring._props = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
          horizontal-view-movement.spring._props = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };

        _children = [
          {
            window-rule = {
              geometry-corner-radius = [
                8.
                8.
                8.
                8.
              ];
              clip-to-geometry = true;
            };
          }

          # Open the Firefox picture-in-picture player as floating by default.
          {
            window-rule = {
              match._props = {
                app-id = "firefox$";
                title = "^Picture-in-Picture$";
              };
              open-floating = true;
            };
          }

          {
            window-rule = {
              match._props.app-id = "^(c|C)ode$";
              draw-border-with-background = false;
              opacity = 0.9;
            };
          }

          {
            window-rule._children = [
              { match._props.app-id = "^Emacs$"; }
              { match._props.app-id = "^dev.zed.Zed$"; }
              { draw-border-with-background = false; }
              { opacity = 0.95; }
            ];
          }

          {
            layer-rule = {
              match._props.namespace = "^rofi$";
              shadow.on = { };
            };
          }
        ];
      };
    };
}
