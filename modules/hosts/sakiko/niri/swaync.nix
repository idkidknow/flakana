{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.swaynotificationcenter ];
      programs.niri.settings.spawn-at-startup = [ { argv = [ "swaync" ]; } ];
    };
}
