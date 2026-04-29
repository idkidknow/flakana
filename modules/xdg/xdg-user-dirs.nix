{
  flake.modules.homeManager.common-desktop =
    { ... }:
    {
      xdg.userDirs = {
        enable = true;
        createDirectories = true;
        setSessionVariables = false;
      };
    };
}
