{ self, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      mill = self.packages.${system}.mill-unwrapped;
      graalvm = pkgs.graalvmPackages.graalvm-ce;
      reachabilityMetadata = pkgs.fetchzip {
        url = "https://github.com/oracle/graalvm-reachability-metadata/releases/download/0.3.32/graalvm-reachability-metadata-0.3.32.zip";
        hash = "sha256-gLNDZ8VOLm+JbUNmgI3Ji7jWTMoh9FQ1c6MHnbH4bps=";
        stripRoot = false;
      };
      my-scripts-unwrapped = pkgs.callPackage ./_package.nix {
        inherit mill reachabilityMetadata;
      };
    in
    {
      packages.my-scripts =
        pkgs.runCommand "my-scripts-${my-scripts-unwrapped.version}"
          {
            inherit (my-scripts-unwrapped) version meta;
            nativeBuildInputs = [ pkgs.makeWrapper ];
            passthru.unwrapped = my-scripts-unwrapped;
          }
          ''
            makeWrapper ${my-scripts-unwrapped}/bin/my "$out/bin/my" \
              --prefix PATH : ${
                pkgs.lib.makeBinPath [
                  pkgs.jujutsu
                  pkgs.gitMinimal
                  pkgs.openssh
                  pkgs.rsync
                  pkgs.ripgrep
                  pkgs.gh
                ]
              }
          '';

      devShells.my-scripts = pkgs.mkShell {
        packages = [
          graalvm
          mill
          self.packages.${system}.mtf
          pkgs.bubblewrap
          pkgs.metals
        ];

        env = {
          JAVA_HOME = graalvm.home;
          GRAALVM_HOME = graalvm.home;
          GRAALVM_REACHABILITY_METADATA = reachabilityMetadata;
        };

      };
    };

  flake.modules.homeManager.common =
    { pkgs, ... }:
    {
      home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.my-scripts ];
    };
}
