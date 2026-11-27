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
        hash = "sha256-bx6fdIToVjXjf+TBEE62iPR4bXANCv+2yu6h2lTq00c=";
      };
      x86_64-linux = {
        suffix = "native-linux-amd64";
        hash = "sha256-QCLkY9aHkdtiu7gVUQ+RV15EUHiDupYqa9fAMFw2dGI=";
      };
    }
    .${stdenvNoCC.hostPlatform.system};

  unwrapped = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "mill-unwrapped";
    version = "1.4.0";

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
