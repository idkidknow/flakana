{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages =
        let
          mill = pkgs.callPackage ./_package.nix { };
        in
        {
          inherit mill;
          mill-unwrapped = mill.unwrapped;
        };
    };
}
