final: prev:
let
  inherit (final) resolveBuildSystem;
  inherit (builtins) mapAttrs;

  # Build system dependencies specified in the shape expected by resolveBuildSystem
  # The empty lists below are lists of optional dependencies.
  #
  # A package `foo` with specification written as:
  # `setuptools-scm[toml]` in pyproject.toml would be written as
  # `foo.setuptools-scm = [ "toml" ]` in Nix
  buildSystemOverrides = {
    aiohttp.setuptools = [ ];
    asyncpg.setuptools = [ ];
    cffi.setuptools = [ ];
    brotli.setuptools = [ ];
    ciso8601.setuptools = [ ];
    cryptg.setuptools = [ ];
    cryptg.setuptools-rust = [ ];
    contourpy.meson = [ ];
    isal.setuptools = [ ];
    kiwisolver.setuptools = [ ];
    lxml.setuptools = [ ];
    minify-html.maturin = [ ];
    minify-html-onepass.maturin = [ ];
    orjson.maturin = [ ];
    pyaes.setuptools = [ ];
    pycares.setuptools = [ ];
    pydantic-core.maturin = [ ];
    pillow.setuptools = [ ];
    matplotlib.meson = [ ];
    sgmllib3k.setuptools = [ ];
    uvloop.setuptools = [ ];
    rapidfuzz.scikit-build-core = [ ];
    numpy.meson = [ ];
  };

in
mapAttrs (
  name: spec:
  prev.${name}.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ resolveBuildSystem spec;
  })
) buildSystemOverrides
