{
  flake.modules.homeManager.common =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.carapace ];
      xdg.dataFile."nushell/vendor/autoload/carapace.nu".source = "${pkgs.runCommand "carapace.nu" { } ''
        ${lib.getExe pkgs.carapace} _carapace nushell > "$out"
      ''}";
    };
}
