{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      programs.alacritty.enable = true;
    };
}
