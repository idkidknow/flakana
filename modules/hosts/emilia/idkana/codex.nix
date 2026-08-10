{ inputs, ... }:
{
  flake.modules.homeManager."idkana@emilia" =
    { pkgs, ... }:
    let
      bwrap-no-proc = pkgs.writeShellScriptBin "bwrap" ''
        set -euo pipefail

        args=()
        skip_next=0
        for arg in "$@"; do
          if ((skip_next)); then
            skip_next=0
            continue
          fi
          case "$arg" in
            --proc)
              skip_next=1
              ;;
            --proc=*)
              ;;
            *)
              args+=("$arg")
              ;;
          esac
        done

        exec "${pkgs.bubblewrap}/bin/bwrap" "''${args[@]}"
      '';

      codex-no-proc = inputs.llm-agents.packages.aarch64-linux.codex.override {
        bubblewrap = bwrap-no-proc;
      };

      codex = pkgs.writeShellScriptBin "codex" ''
        unset __ETC_PROFILE_NIX_SOURCED
        exec -a codex ${codex-no-proc}/bin/codex "$@"
      '';
    in
    {
      home.packages = [
        codex
      ];
    };
}
