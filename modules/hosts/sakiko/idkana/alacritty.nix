{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      programs.alacritty = {
        enable = true;
        niri-flake-settings.enable = true;
      };
    };
}
