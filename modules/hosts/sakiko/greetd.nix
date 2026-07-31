{ inputs, ... }:
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
          name = "Materia-dark";
          package = inputs.nixpkgs-335f0738.legacyPackages.x86_64-linux.materia-theme;
        };
        cursorTheme = {
          name = "macOS";
          package = pkgs.apple-cursor;
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
