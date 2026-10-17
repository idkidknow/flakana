{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      packages.mtf = inputs.mvn-trace-forge.packages.${system}.mtf.override {
        zulu = pkgs.jdk25;
      };
    };
}
