{
  flake.modules.nixos.common-desktop =
    { ... }:
    {
      xdg.menus.enable = true;
    };
  flake.modules.homeManager.common-desktop =
    { ... }:
    {
      xdg.configFile."menus/applications.menu".source = ./applications.menu;
    };
}
