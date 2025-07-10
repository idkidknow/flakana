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
      home.packages = with pkgs; [
        xwayland-satellite
        swaynotificationcenter
        rofi-wayland
      ];

      programs.waybar = {
        enable = true;
      };
    };
}
