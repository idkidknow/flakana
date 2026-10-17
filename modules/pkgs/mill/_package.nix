{
  autoPatchelfHook,
  fetchurl,
  jdk25,
  makeWrapper,
  runCommand,
  stdenvNoCC,
  zlib,
}:

let
  source =
    {
      aarch64-linux = {
        suffix = "native-linux-aarch64";
        hash = "sha256-rjZpyeXzFTFIoNYAVMOHwnzUYh45Ir3RX3HYhYR3mc4=";
      };
      x86_64-linux = {
        suffix = "native-linux-amd64";
        hash = "sha256-pY9O2Pl+dLxopknRifCqr0bVHRFq/m0pfJBPnfVWA7U=";
      };
    }
    .${stdenvNoCC.hostPlatform.system};

  unwrapped = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "mill-unwrapped";
    version = "1.3.0";

    src = fetchurl {
      url = "https://repo1.maven.org/maven2/com/lihaoyi/mill-dist-${source.suffix}/${finalAttrs.version}/mill-dist-${source.suffix}-${finalAttrs.version}.exe";
      inherit (source) hash;
    };

    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ zlib ];

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      install -Dm555 "$src" "$out/bin/mill"
      runHook postInstall
    '';

    meta.mainProgram = "mill";
  });
in
runCommand "mill-${unwrapped.version}"
  {
    inherit (unwrapped) version;
    nativeBuildInputs = [ makeWrapper ];
    passthru = { inherit unwrapped; };
    meta.mainProgram = "mill";
  }
  ''
    # wrapProgram sets --argv0, which the native launcher does not support.
    makeWrapper ${unwrapped}/bin/mill "$out/bin/mill" \
      --prefix PATH : "${jdk25}/bin" \
      --set JAVA_HOME "${jdk25.home}"
  ''
