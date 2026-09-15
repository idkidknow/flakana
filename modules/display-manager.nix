{
  flake.modules.nixos.common-desktop = { pkgs, ... }: {
    services.displayManager.noctalia-greeter = {
      enable = true;
      cursorTheme = {
        name = "macOS";
        package = pkgs.apple-cursor;
      };
    };
  };
}
