{
  flake.modules.nixos.common-desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        kdePackages.breeze
        kdePackages.breeze-icons
        kdePackages.breeze-gtk
      ];

      xdg.icons = {
        enable = true;
        fallbackCursorThemes = [ "breeze_cursors" ];
      };
    };

  flake.modules.homeManager.common-desktop =
    { ... }:
    {
      qt = {
        enable = true;
        platformTheme.name = "qtct";
      };
    };
}
