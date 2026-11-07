let
  emacsMinimal =
    pkgs:
    pkgs.emacs-nox.pkgs.withPackages (
      epkgs: with epkgs; [
        just-ts-mode
        mwim
        nix-ts-mode
        scala-ts-mode
        smartparens
        undo-fu
        vundo
        treesit-grammars.with-all-grammars
      ]
    );

  wrapper =
    pkgs:
    let
      emacs = emacsMinimal pkgs;
      initDirectory = pkgs.runCommand "emacs-minimal-init" { } ''
        mkdir -p "$out"
        cp ${./early-init.el} "$out/early-init.el"
        cp ${./init.el} "$out/init.el"
        substituteInPlace "$out/early-init.el" \
          --replace-fail '@treesitGrammarPath@' '${emacs.deps}/lib'
        ${emacs}/bin/emacs --batch --quick \
          -f batch-byte-compile "$out/early-init.el" "$out/init.el"
      '';
    in
    pkgs.writeShellScriptBin "e" ''
      exec ${emacs}/bin/emacs --no-site-file --init-directory ${initDirectory} "$@"
    '';
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.emacs-minimal = emacsMinimal pkgs;
    };

  flake.modules.nixos.common =
    { pkgs, ... }:
    {
      environment.systemPackages = [ (wrapper pkgs) ];
    };

  flake.modules.homeManager.common =
    { pkgs, ... }:
    {
      home.packages = [ (wrapper pkgs) ];
    };
}
