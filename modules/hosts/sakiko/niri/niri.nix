{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      programs.niri.enable = true;
    };

  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      xdg.configFile."niri/config.kdl".source = ./config.kdl;

      home.packages = with pkgs; [
        xwayland-satellite
        swaynotificationcenter
        rofi-wayland
        nautilus # https://github.com/YaLTeR/niri/issues/702
      ];

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
    };
}
