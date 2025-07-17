{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.addons = with pkgs; [
          kdePackages.fcitx5-chinese-addons
          fcitx5-rime
          fcitx5-gtk
          kdePackages.fcitx5-qt
          fcitx5-mozc
          fcitx5-mellow-themes
        ];
      };

      environment.variables = {
        QT_IM_MODULE = "fcitx";
      };
    };
}
