{
  config,
  self,
  ...
}:
let
  pkgs-master = config.nixpkgsInstances.master-x86_64-linux;
in
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
        maa-cli
        obsidian
        vesktop
        (self.lib.electronFixIME vscode)
        pkgs-master.jetbrains.idea-community-bin
        isd
        peazip
        kdePackages.okular
        krita
        xournalpp
        splayer
        (element-desktop |> self.lib.electronFixIME |> self.lib.electronUseGnomeLibsecret)
        obs-studio
        kdePackages.kdenlive
        wl-clipboard
        wakatime-cli
        anki
      ];

      systemd.user.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
}
