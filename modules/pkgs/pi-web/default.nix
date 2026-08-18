{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.pi-web = pkgs.callPackage ./_package.nix { };
    };
}
