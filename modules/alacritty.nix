{
  flake.modules.homeManager.common-desktop =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

      programs.alacritty = {
        enable = true;
        settings = {
          window.decorations = "None";
          window.opacity = 0.9;

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
