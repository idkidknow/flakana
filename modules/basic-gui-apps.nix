{
  flake.modules.homeManager.common-desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        firefox
        telegram-desktop
        libreoffice-qt
      ];
    };
}
