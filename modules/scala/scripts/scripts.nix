{ self, ... }:
let
  mkScalaWriter =
    pkgs: writeScript:
    let
      jdk = pkgs.jdk25;
      mill = self.packages.${pkgs.stdenv.hostPlatform.system}.mill-unwrapped;
      m2 = pkgs.mkMavenRepository {
        lockFile = ./mtf.lock.json;
      };
      writeScala =
        name:
        {
          main ? false,
        }:
        text:
        let
          source =
            if main then
              let
                body = pkgs.lib.concatMapStringsSep "\n" (line: "    ${line}") (pkgs.lib.splitString "\n" text);
              in
              ''
                object Main {
                  def main(args: Array[String]): Unit = {
                ${body}
                  }
                }
              ''
            else
              text;
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
              cp ${pkgs.writeText "main.scala" source} src/main.scala

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
        writeScript name ''
          exec ${jdk}/bin/java \
            --sun-misc-unsafe-memory-access=allow \
            -cp "$(< ${compiled}/classpath):${compiled}/script.jar" \
            "$(< ${compiled}/main-class)" "$@"
        '';

    in
    name: argsOrText:
    if pkgs.lib.isAttrs argsOrText && !pkgs.lib.isDerivation argsOrText then
      writeScala name argsOrText
    else
      writeScala name { } argsOrText;
in
{
  flake.lib.mkWriteScala = pkgs: mkScalaWriter pkgs pkgs.writeShellScript;
  flake.lib.mkWriteScalaBin = pkgs: mkScalaWriter pkgs pkgs.writeShellScriptBin;
}
