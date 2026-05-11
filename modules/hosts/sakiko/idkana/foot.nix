{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      programs.foot = {
        enable = true;
        settings = {
          main = {
            font = "JetBrainsMono Nerd Font:size=12";
            dpi-aware = "yes";
          };
          csd = {
            preferred = "none";
          };
          mouse = {
            hide-when-typing = "yes";
          };
        };
      };

      programs.niri.settings.binds = {
        "Mod+0" = {
          repeat = false;
          action.spawn = "foot";
        };
      };
    };
}
