{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      programs.regreet = {
        enable = true;
        cageArgs = [
          "-s"
          "-d"
          "-m"
          "last"
        ];
        theme = {
          name = "Canta-dark";
          package = pkgs.canta-theme;
        };
        cursorTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };
        font = {
          name = "JetBrainsMono Nerd Font";
          size = 16;
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        settings.GTK.application_prefer_dark_theme = true;
      };
    };
}
