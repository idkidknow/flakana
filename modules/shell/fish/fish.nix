{ ... }:
{
  flake.modules.homeManager.common =
    { ... }:
    {
      programs.fish = {
        enable = true;
        shellInit = builtins.readFile ./config.fish;
        interactiveShellInit = builtins.readFile ./config-interactive.fish;
      };

      xdg.configFile."fish/functions" = {
        source = ./functions;
        recursive = true;
      };
    };
}
