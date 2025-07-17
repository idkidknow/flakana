{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      services.displayManager.sddm = {
        enable = true;
        wayland = {
          enable = true;
          compositor = "weston";
        };
      };
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
    };
}
