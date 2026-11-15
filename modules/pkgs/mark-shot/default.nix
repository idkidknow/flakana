{
  perSystem =
    { pkgs, ... }:
    {
      packages.mark-shot = pkgs.callPackage ./_package.nix { };
    };
}
