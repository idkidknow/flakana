{
  inputs,
  config,
  self,
  ...
}:
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
        duf
        just
        tealdeer
        nix-output-monitor
        nh
        google-chrome
        wev
        pwvucontrol
        mission-center
        cage
        libnotify
        qview
        zed-editor
        kdePackages.dolphin
        kdePackages.dolphin-plugins
        inputs.nixpkgs-master.legacyPackages.x86_64-linux.maa-cli
        obsidian
        vesktop
        (self.lib.electronFixIME vscode)
        inputs.nixpkgs-master.legacyPackages.x86_64-linux.jetbrains.idea-community-bin
        isd
        peazip
        kdePackages.okular
        krita
        xournalpp
        splayer
        (element-desktop |> self.lib.electronFixIME |> self.lib.electronUseGnomeLibsecret)
        obs-studio
        kdePackages.kdenlive
      ];
    };
}
