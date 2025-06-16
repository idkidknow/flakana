{
  flake.modules.homeManager.common =
    { pkgs, lib, ... }:
    {
      home.packages = [ pkgs.zoxide ];
      xdg.dataFile."nushell/vendor/autoload/zoxide.nu".source = "${pkgs.runCommand "zoxide.nu" { } ''
        ${lib.getExe pkgs.zoxide} init nushell > "$out"
      ''}";
    };
}
