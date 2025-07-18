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
        (inputs.nixpkgs-master.legacyPackages.x86_64-linux.maa-cli.override {
          maa-assistant-arknights =
            inputs.nixpkgs-master.legacyPackages.x86_64-linux.maa-assistant-arknights.overrideAttrs
              {
                version = "5.20.0";
                src = fetchFromGitHub {
                  owner = "MaaAssistantArknights";
                  repo = "MaaAssistantArknights";
                  rev = "v5.20.0";
                  hash = "sha256-XqzCxzmNJHG+aYBJoeAAryFx3XctrGBk6QqoonCbrWU=";
                };
              };
        })
        obsidian
        vesktop
        (vscode.override {
          # Fix the issue that the IME does not work when NIXOS_OZONE_WL=1
          commandLineArgs = "--wayland-text-input-version=3";
        })
        jetbrains.idea-community-bin
        isd
        peazip
        kdePackages.okular
      ];
    };
}
