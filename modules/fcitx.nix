{ withSystem, ... }:
{
  flake.modules.nixos.common-desktop =
    { pkgs, ... }:
    let
      pkgs-master = withSystem pkgs.stdenv.hostPlatform.system (
        { config, ... }: config.nixpkgsInstances.master
      );
    in
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
          # track: https://github.com/NixOS/nixpkgs/pull/531687
          pkgs-master.fcitx5-mozc
          fcitx5-mellow-themes
        ];
      };

      environment.variables = {
        QT_IM_MODULE = "fcitx";
        QT_IM_MODULES = "wayland;fcitx;ibus";
      };
    };
}
