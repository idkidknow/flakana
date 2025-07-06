{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      services.xserver.enable = true;
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      services.desktopManager.plasma6.enable = true;

      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.plasma6Support = true;
        fcitx5.addons = with pkgs; [
          kdePackages.fcitx5-chinese-addons
          fcitx5-rime
          fcitx5-gtk
          kdePackages.fcitx5-qt
          fcitx5-mozc
        ];
      };
    };
}
