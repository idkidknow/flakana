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
        zellij
        fzf
        dua
        just
        tealdeer
        nix-output-monitor
        nh
        (inputs.nixpkgs-master.legacyPackages.x86_64-linux.hmcl.override {
          hmclJdk = jdk24;
        })
        google-chrome
        wev
        snipaste
        pavucontrol
        mission-center
        cage
        libnotify
        swayimg
        zed-editor
        kdePackages.dolphin
        kdePackages.dolphin-plugins
        maa-cli
      ];
    };
}
