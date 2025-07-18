{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      xdg.userDirs = {
        enable = true;
        createDirectories = true;
      };
    };
}
