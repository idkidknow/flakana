{
  flake.modules.homeManager.common-gui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

      programs.alacritty = {
        enable = true;
        settings = {
          window.decorations = "None";

          font.normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };

          cursor.style = {
            shape = "Beam";
            blinking = "On";
          };
        };
      };
    };
}
