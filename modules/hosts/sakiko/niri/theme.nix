{
  flake.modules.nixos."hosts/sakiko" =
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
}
