{
  flake.modules.homeManager."idkana@sakiko" =
    { lib, config, ... }:
    {
      programs.foot = {
        enable = true;
        settings = {
          main = {
            shell = lib.mkIf (config.programs.fish.enable) "${lib.getExe config.programs.fish.package}";
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
