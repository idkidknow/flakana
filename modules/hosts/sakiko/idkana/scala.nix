{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    let
      ammonite = pkgs.ammonite.overrideAttrs {
        version = "3.0.8";
        src = pkgs.fetchurl {
          url = "https://github.com/lihaoyi/Ammonite/releases/download/3.0.8/3.8-3.0.8";
          hash = "sha256-bpqnAZuW1Oy+w8OGhP+BwDw6E/xruaAMlt0rv5z2pG0=";
        };
      };

      scala-cli = pkgs.scala-cli;
      # scala-cli = pkgs.scala-cli.overrideAttrs (
      #   prev:
      #   let
      #     version = "1.11.0";
      #     hash = "sha256-eXxRwAZnvPep8/xK5uhAFHOYxQ2PICP5KRTSgqgrbcs=";
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
