{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, lib, ... }:
    let
      # scala-cli = pkgs.scala-cli;
      scala-cli = pkgs.scala-cli.overrideAttrs (
        prev:
        let
          version = "1.15.0";
          hash = "sha256-N7M5Of+CqHMCY7bHLYHiPbSYe0s5nIpAPI7OdmBKMPY=";
        in
        {
          version =
            assert lib.assertMsg (lib.versionOlder prev.version version) ''
              There is newer or equal version (scala-cli ${prev.version}) in nixpkgs.
            '';
            version;
          src = pkgs.fetchurl {
            url = "https://github.com/Virtuslab/scala-cli/releases/download/v${version}/scala-cli-x86_64-pc-linux.gz";
            inherit hash;
          };
        }
      );
    in
    {
      home.packages = [
        scala-cli
      ];
    };
}
