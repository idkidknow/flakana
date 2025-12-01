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
        hotkey-overlay.skip-at-startup = true;

        binds = with config.lib.niri.actions; {
          "Mod+D" = {
            action = spawn "rofi" "-show" "drun";
            hotkey-overlay.title = "rofi drun";
          };
        };

        debug.honor-xdg-activation-with-invalid-serial = [ ];

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
              { app-id = "^(c|C)ode$"; }
            ];
            draw-border-with-background = false;
            opacity = 0.9;
          }

          {
            matches = [
              { app-id = "^Emacs$"; }
              { app-id = "^dev.zed.Zed$"; }
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
