{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  pyproject-nix,
  uv2nix,
  pyproject-build-systems,
  ...
}:
let
  patched = stdenv.mkDerivation rec {
    pname = "rsstt-src";
    version = "2.10.0";
    src = fetchFromGitHub {
      owner = "Rongronggg9";
      repo = "RSS-to-Telegram-Bot";
      tag = "v${version}";
      hash = "sha256-1XY8xnrAM1dqkZRpb3o4mn6Y5OSryKTxFFADWE1aiOQ=";
    };
    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out
      rm $out/pyproject.toml
      cp ${./pyproject.toml} $out/pyproject.toml
      cp ${./uv.lock} $out/uv.lock
      substituteInPlace $out/setup.py \
        --replace-fail "package_dir={'rsstt': 'src'}," \
                       "package_dir={'rsstt': 'src'}, entry_points={'console_scripts':['rsstt=rsstt.entrypoint:main']},"
    '';
  };

  workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = "${patched}"; };

  overlay = workspace.mkPyprojectOverlay {
    sourcePreference = "wheel";
  };

  python = pkgs.python312;

  pythonSet =
    (pkgs.callPackage pyproject-nix.build.packages {
      inherit python;
    }).overrideScope
      (
        lib.composeManyExtensions [
          pyproject-build-systems.overlays.default
          overlay
          (import ./_build-system-overrides.nix)
        ]
      );

  inherit (pkgs.callPackages pyproject-nix.build.util { }) mkApplication;

  venv = pythonSet.mkVirtualEnv "rsstt-env" workspace.deps.default;
in
mkApplication {
  venv = venv;
  package = pythonSet.rsstt;
}
