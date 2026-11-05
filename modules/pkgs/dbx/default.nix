{ lib, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      packages = lib.optionalAttrs (system == "x86_64-linux") {
        dbx = pkgs.callPackage ./_package.nix { };
      };
    };
}
