{ self, ... }:
{
  flake.lib.mkWriteScalaScript =
    pkgs:
    let
      jdk = pkgs.jdk25;
      mill = self.packages.${pkgs.stdenv.hostPlatform.system}.mill-unwrapped;
      m2 = pkgs.mkMavenRepository {
        lockFile = ./mtf.lock.json;
      };
    in
    name: text:
    let
      compiled = pkgs.stdenvNoCC.mkDerivation {
        name = "${name}-scala";

        dontUnpack = true;
        dontConfigure = true;
        strictDeps = true;

        nativeBuildInputs = [
          jdk
          mill
          m2
        ];

        env.JAVA_HOME = jdk.home;

        buildPhase = ''
          runHook preBuild

          mkdir -p src
          cp ${./build.mill} build.mill
          cp ${./prelude.scala} src/prelude.scala
          cp ${pkgs.writeText "main.scala" text} src/main.scala

          mill --no-daemon scriptBundle

          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall

          cp -r out/scriptBundle.dest "$out"

          runHook postInstall
        '';
      };
    in
    pkgs.writeShellScript name ''
      exec ${jdk}/bin/java \
        --sun-misc-unsafe-memory-access=allow \
        -cp "$(< ${compiled}/classpath):${compiled}/script.jar" \
        "$(< ${compiled}/main-class)" "$@"
    '';

  flake.lib.mkWriteScalaScriptMain =
    pkgs: name: text:
    let
      body = pkgs.lib.concatMapStringsSep "\n" (line: "    ${line}") (pkgs.lib.splitString "\n" text);
    in
    self.lib.mkWriteScalaScript pkgs name ''
      object Main {
        def main(args: Array[String]): Unit = {
      ${body}
        }
      }
    '';
}
