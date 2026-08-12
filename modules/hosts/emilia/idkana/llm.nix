{ inputs, ... }:
{
  flake.modules.homeManager."idkana@emilia" =
    { pkgs, ... }:
    let
      codex = pkgs.writeShellScriptBin "codex" ''
        unset __ETC_PROFILE_NIX_SOURCED
        exec -a codex ${inputs.llm-agents.packages.aarch64-linux.codex}/bin/codex "$@"
      '';
      pi = inputs.llm-agents.packages.aarch64-linux.pi;
    in
    {
      home.packages = [
        codex
        pi
      ];
    };
}
