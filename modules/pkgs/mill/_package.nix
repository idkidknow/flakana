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
        hash = "sha256-/p9tDYqbks1JJqWy1tAGcGoE98hWZH23cSvospb46oo=";
      };
      x86_64-linux = {
        suffix = "native-linux-amd64";
        hash = "sha256-+5Sqk4mAPwMwyAq+ZDC6hCc0bLQdvAZmQY1S984focQ=";
      };
    }
    .${stdenvNoCC.hostPlatform.system};

  unwrapped = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "mill-unwrapped";
    version = "1.3.1";

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
