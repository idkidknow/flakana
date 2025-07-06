{
  flake.modules.homeManager.common-gui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        firefox
        telegram-desktop
        libreoffice-qt
      ];
    };
}
