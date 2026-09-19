{ inputs, ... }:
{
  flake.modules.nixos.common-desktop =
    { pkgs, lib, ... }:
    let
      # track: https://github.com/fcitx/fcitx5/issues/1668 https://github.com/sanweiya/fcitx5-mellow-themes/issues/6
      old-pkgs = inputs.nixpkgs-8ce4ef6c.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      fcitx5-addons = with old-pkgs; [
        kdePackages.fcitx5-chinese-addons
        fcitx5-rime
        fcitx5-gtk
        kdePackages.fcitx5-qt
        fcitx5-mozc
        fcitx5-mellow-themes
      ];
    in
    {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        package = lib.mkForce (
          old-pkgs.qt6Packages.fcitx5-with-addons.override { addons = fcitx5-addons; }
        );
        fcitx5.waylandFrontend = true;
        fcitx5.addons = fcitx5-addons;
      };

      environment.variables = {
        QT_IM_MODULE = "fcitx";
        QT_IM_MODULES = "wayland;fcitx;ibus";
      };
    };
}
