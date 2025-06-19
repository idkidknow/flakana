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
        version = "0.4.0";
        src = pkgs.fetchFromGitLab {
          owner = "lanastara_foss";
          repo = "starship-jj";
          tag = finalAttrs.version;
          hash = "sha256-LVTFgYfbqqdqrr2LpzX7dJwWsXfB74wW22jm1Ok57gs=";
        };

        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [ pkgs.openssl ];

        cargoHash = "sha256-d72KCMR8KJ0pbVWqn8sHmDgT5DFTyIv40rF51yLLsnY=";

        meta.mainProgram = "starship-jj";
      });
    };
}
