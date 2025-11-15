{ self, ... }:
{
  flake.modules.homeManager.common =
    { pkgs, lib, ... }:
    let
      starship-jj = self.packages.${pkgs.stdenv.hostPlatform.system}.starship-jj;
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
          command = "prompt"
          shell = ["${lib.getExe starship-jj}", "--ignore-working-copy", "starship"]
          ignore_timeout = true
          format = "$output"
          use_stdin = false
          when = true
        '')
      ];
      xdg.configFile."starship-jj/starship-jj.toml".source = ./starship-jj.toml;
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.starship-jj = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "starship-jj";
        version = "0.6.1";
        src = pkgs.fetchFromGitLab {
          owner = "lanastara_foss";
          repo = "starship-jj";
          tag = finalAttrs.version;
          hash = "sha256-KYNDutr+2UGATpQu9oVrer4hh+eF4FynbcIvc4hH5qQ=";
        };

        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [ pkgs.openssl ];

        cargoHash = "sha256-vRgBnFMOgkc9FvLG/irraq+JSTu17lNuKpq9jNE9N7o=";

        meta.mainProgram = "starship-jj";
      });
    };
}
