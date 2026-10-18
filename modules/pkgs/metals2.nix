{
  perSystem =
    { pkgs, ... }:
    {
      packages.metals2 = pkgs.metals.overrideAttrs (oldAttrs: {
        version = "2.0.0-RC1";
        passthru = oldAttrs.passthru // {
          deps = oldAttrs.passthru.deps.overrideAttrs {
            outputHash = "sha256-upK1+pQmbA6ATYzwydxOg/6dipH+MBbr2UXgVDqng1U=";
          };
        };
      });
    };
}
