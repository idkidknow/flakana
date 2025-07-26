{ inputs, config, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      imports = [
        config.flake.modules.homeManager.common
        config.flake.modules.homeManager.common-desktop
      ];

      home.stateVersion = "25.05";
      home.username = "idkana";
      home.homeDirectory = "/home/idkana";

      home.packages = with pkgs; [
        emacs
        fastfetch
        gitui
        git-lfs
        jujutsu
        fzf
        dua
        just
        tealdeer
        nix-output-monitor
        nh
        google-chrome
        wev
        pavucontrol
        mission-center
        cage
        libnotify
        qview
        zed-editor
        kdePackages.dolphin
        kdePackages.dolphin-plugins
        maa-cli
        obsidian
        vesktop
        (vscode.override {
          # Fix the issue that the IME does not work when NIXOS_OZONE_WL=1
          commandLineArgs = "--wayland-text-input-version=3";
        })
        inputs.nixpkgs-master.legacyPackages.x86_64-linux.jetbrains.idea-community-bin
        inputs.nixpkgs-9807714.legacyPackages.x86_64-linux.isd
        peazip
        kdePackages.okular
        krita
        xournalpp
      ];
    };
}
