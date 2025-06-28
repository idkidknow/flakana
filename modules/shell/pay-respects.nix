{
  flake.modules.homeManager.common =
    { pkgs, lib, ... }:
    {
      programs.pay-respects = {
        enable = true;
      };

      # https://github.com/nushell/nushell/issues/11712
      xdg.dataFile."nushell/vendor/autoload/pay-respects.nu".source = "${pkgs.runCommand "pay-respects.nu"
        { }
        ''
          ${lib.getExe pkgs.pay-respects} nushell --nocnf > pay-respects.nu
          substituteInPlace pay-respects.nu \
            --replace "(history | last).command" "((history).command | get ((\$in | length) - 2))"
          cp pay-respects.nu "$out"
        ''
      }";
    };
}
