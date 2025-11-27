{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, lib, ... }:
    let
      ammonite = pkgs.ammonite.overrideAttrs (prev: {
        version = "3.0.4";
        src = pkgs.fetchurl {
          url = "https://github.com/lihaoyi/Ammonite/releases/download/3.0.4/3.7-3.0.4";
          hash = "sha256-csAS0zOcQTIsIN5B3ohgkPbI258ocuk4qzE8wlrXCpw=";
        };
        nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
        # track: https://github.com/uutils/coreutils/issues/8608
        installPhase = prev.installPhase + ''
          wrapProgram $out/bin/amm --prefix PATH ":" ${lib.makeBinPath [ pkgs.coreutils ]}
        '';
      });

      scala-cli = pkgs.scala-cli;
      # scala-cli = pkgs.scala-cli.overrideAttrs (
      #   prev:
      #   let
      #     version = "1.10.1";
      #     hash = "sha256-1c96rxbxTznwY1gLV5nNPJOZwBhLqw+4Z5ZxVX1J2F4=";
      #   in
      #   {
      #     version =
      #       assert lib.assertMsg (lib.versionOlder prev.version version) ''
      #         There is newer or equal version (scala-cli ${prev.version}) in nixpkgs.
      #       '';
      #       version;
      #     src = pkgs.fetchurl {
      #       url = "https://github.com/Virtuslab/scala-cli/releases/download/v${version}/scala-cli-x86_64-pc-linux.gz";
      #       inherit hash;
      #     };
      #   }
      # );
    in
    {
      home.packages = [
        ammonite
        scala-cli
      ];
    };
}
