{ self, ... }:
{
  flake.modules.homeManager.common =
    { pkgs, lib, ... }:
    let
      starship-jj = self.packages.${pkgs.stdenv.hostPlatform.system}.starship-jj;
    in
    {
      programs.starship = {
        enable = true;
        enableNushellIntegration = true;
        enableFishIntegration = true;
        settings = (fromTOML (builtins.readFile ./starship.toml)) // {
          custom.jj = {
            command = "prompt";
            shell = [
              (lib.getExe starship-jj)
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

  perSystem =
    { pkgs, ... }:
    {
      packages.starship-jj = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "starship-jj";
        version = "0.7.0";
        src = pkgs.fetchFromGitLab {
          owner = "lanastara_foss";
          repo = "starship-jj";
          tag = finalAttrs.version;
          hash = "sha256-EgOKjPJK6NdHghMclbn4daywJ8oODiXkS48Nrn5cRZo=";
        };

        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [ pkgs.openssl ];

        cargoHash = "sha256-NNeovW27YSK/fO2DjAsJqBvebd43usCw7ni47cgTth8=";

        meta.mainProgram = "starship-jj";
      });
    };
}
