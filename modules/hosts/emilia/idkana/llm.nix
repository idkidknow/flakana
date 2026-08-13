{ inputs, ... }:
{
  flake.modules.homeManager."idkana@emilia" =
    { pkgs, ... }:
    let
      codex = pkgs.writeShellScriptBin "codex" ''
        unset __ETC_PROFILE_NIX_SOURCED
        exec -a codex ${inputs.llm-agents.packages.aarch64-linux.codex}/bin/codex "$@"
      '';
      pi-unwrapped = inputs.llm-agents.packages.aarch64-linux.pi;
      pi = pkgs.writeShellScriptBin "pi" ''
        export PI_PACKAGE_DIR=${pi-unwrapped}/libexec/pi
        export PI_SKIP_VERSION_CHECK=1
        export PI_TELEMETRY=0

        exec ${pkgs.stdenv.cc.bintools.dynamicLinker} \
          --argv0 pi \
          ${pi-unwrapped}/libexec/pi/pi \
          "$@"
      '';
    in
    {
      home.packages = [
        codex
        pi
      ];
    };
}
