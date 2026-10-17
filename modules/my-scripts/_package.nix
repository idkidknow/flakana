{
  lib,
  stdenv,
  graalvmPackages,
  mill,
  mkMavenRepository,
  reachabilityMetadata,
}:
let
  graalvm = graalvmPackages.graalvm-ce;
  m2 = mkMavenRepository {
    lockFile = ./mtf.lock.json;
  };
in
stdenv.mkDerivation {
  pname = "my-scripts";
  version = "0.1.0";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./build.mill
      ./src
    ];
  };

  strictDeps = true;
  nativeBuildInputs = [
    graalvm
    mill
    m2
  ];

  env = {
    JAVA_HOME = graalvm.home;
    GRAALVM_HOME = graalvm.home;
    GRAALVM_REACHABILITY_METADATA = reachabilityMetadata;
  };

  buildPhase = ''
    runHook preBuild

    mill --no-daemon nativeImage

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 out/nativeImage.dest/native-executable "$out/bin/my"

    runHook postInstall
  '';

  meta = {
    mainProgram = "my";
  };
}
