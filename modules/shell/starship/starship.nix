{ self, ... }:
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

      xdg.configFile."starship.toml".source = pkgs.concatText "starship.toml" [
        ./starship.toml
        (pkgs.writeText "starship-custom-jj.toml" ''
          [custom.jj]
          command = "${lib.getExe starship-jj} --ignore-working-copy starship prompt"
          format = "[$symbol](blue bold) $output "
          symbol = "󱗆 "
          when = "${lib.getExe pkgs.jujutsu} root --ignore-working-copy"
        '')
      ];
      xdg.configFile."starship-jj/starship-jj.toml".source = ./starship-jj.toml;
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.starship-jj = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "starship-jj";
        version = "0.3.2";
        src = pkgs.fetchFromGitLab {
          owner = "lanastara_foss";
          repo = "starship-jj";
          tag = finalAttrs.version;
          hash = "sha256-+wATQ3uXxUFFQt/Fz8PKZ7NmPzaNPfjWH/gfMXHryO4=";
        };

        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [ pkgs.openssl ];

        cargoHash = "sha256-to+3CJc0em/sEhHj3j4tT8ucqxypz0/JOohpzraJREg=";

        meta.mainProgram = "starship-jj";
      });
    };
}
