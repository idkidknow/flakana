{ inputs, config, ... }:
{
  flake.modules.homeManager."idkana@mutsumi" =
    { pkgs, ... }:
    {
      imports = [ config.flake.modules.homeManager.common ];

      home.stateVersion = "24.11";
      home.username = "idkana";
      home.homeDirectory = "/home/idkana";

      nixpkgs.overlays = [ (import inputs.rust-overlay) ];

      home.packages = with pkgs; [
        emacs
        fastfetch
        carapace
        nurl
        direnv
        clang
        (rust-bin.selectLatestNightlyWith (
          toolchain:
          toolchain.default.override {
            extensions = [
              "rust-src"
              "rust-analyzer"
            ];
            targets = [
              "wasm32-unknown-unknown"
              "wasm32-wasip1"
            ];
          }
        ))
        elan
        openjdk21
        python313
        python313Packages.ipython
        uv
        nix-direnv
        gitui
        git-lfs
        jujutsu
        zellij
        fzf
        dua
        just
        tealdeer
        nix-output-monitor
        nh
        nvfetcher
        taplo-cli
      ];

      nushell.isWSL = true;

    };
}
