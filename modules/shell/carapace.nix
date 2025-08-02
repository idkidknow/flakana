{
  flake.modules.homeManager.common =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.carapace ];
      xdg.dataFile."nushell/vendor/autoload/carapace.nu".source = "${pkgs.runCommand "carapace.nu" { } ''
        str="$(${lib.getExe pkgs.carapace} _carapace nushell)"
        echo "${"$"}{str//get -i/get -o}" > "$out"
      ''}";
    };
}
