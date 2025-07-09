{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
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
