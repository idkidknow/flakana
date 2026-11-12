{ self, ... }:
{
  flake.modules.homeManager.common =
    { pkgs, lib, ... }:
    {
      programs.starship = {
        enable = true;
        enableNushellIntegration = true;
        enableFishIntegration = true;
        settings = (fromTOML (builtins.readFile ./starship.toml)) // {
          custom.jj = {
            command = "prompt";
            shell = [
              (lib.getExe pkgs.starship-jj)
              "--ignore-working-copy"
              "starship"
            ];
            ignore_timeout = true;
            format = "$output";
            use_stdin = false;
            when = true;
          };
        };
      };

      xdg.configFile."starship-jj/starship-jj.toml".source = ./starship-jj.toml;
    };
}
