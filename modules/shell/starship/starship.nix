{ inputs, self, ... }:
{
  flake.modules.homeManager.common =
    { pkgs, lib, ... }:
    let
      starship-jj = self.packages.${pkgs.system}.starship-jj;
    in
    {
      home.packages = [ pkgs.starship ];
      xdg.dataFile."nushell/vendor/autoload/starship.nu".source = "${pkgs.runCommand "starship.nu" { } ''
        ${lib.getExe pkgs.starship} init nu > "$out"
      ''}";
      xdg.configFile."starship.toml".text = ''
        ${lib.readFile ./starship.toml}

        [custom.jj]
        command = "${lib.getExe starship-jj} --ignore-working-copy starship prompt"
        format = "[$symbol](blue bold) $output "
        symbol = "󱗆 "
        when = "${lib.getExe pkgs.jujutsu} root --ignore-working-copy"
      '';
      xdg.configFile."starship-jj/starship-jj.toml".source = ./starship-jj.toml;
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.starship-jj =
        let
          version = "0.3.2";
          src = pkgs.fetchFromGitLab {
            owner = "lanastara_foss";
            repo = "starship-jj";
            tag = version;
            hash = "sha256-+wATQ3uXxUFFQt/Fz8PKZ7NmPzaNPfjWH/gfMXHryO4=";
          };
          naersk' = pkgs.callPackage inputs.naersk { };
        in
        naersk'.buildPackage {
          src = src;
          meta.mainProgram = "starship-jj";
        };
    };
}
