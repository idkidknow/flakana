{ inputs, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      home.packages = [ inputs.hexecute.packages.x86_64-linux.default ];

      programs.niri.settings.binds."Super+Space" = {
        repeat = false;
        action.spawn = "hexecute";
      };
    };
}
