{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      services.xserver.enable = true;
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      services.desktopManager.plasma6.enable = true;

      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
      ];

      i18n.inputMethod.fcitx5.plasma6Support = true;
    };
}
