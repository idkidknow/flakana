{ self, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      install_all_nu =
        ./nu
        |> lib.fileset.toList
        |> lib.map (
          script:
          "install -Dm755 ${script} $out/bin/${script |> builtins.baseNameOf |> lib.removeSuffix ".nu"}"
        )
        |> lib.join "\n";
    in
    {
      packages.my-scripts = pkgs.stdenvNoCC.mkDerivation {
        name = "my-scripts";
        buildInputs = [ pkgs.nushell ];
        dontUnpack = true;
        installPhase = ''
          ${install_all_nu}
        '';
      };
    };

  flake.modules.homeManager.common =
    { pkgs, ... }:
    {
      home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.my-scripts ];
    };
}
