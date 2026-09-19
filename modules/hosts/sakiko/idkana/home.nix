{
  inputs,
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

      flakana.niri.enable = true;

      home.packages = with pkgs; [
        fastfetch
        gitui
        git-lfs
        fzf
        dua
        duf
        tealdeer
        nix-output-monitor
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
        obsidian
        vesktop
        (self.lib.electronFixIME vscode)
        pkgs-master.jetbrains.idea
        isd
        peazip
        kdePackages.okular
        krita
        xournalpp
        (element-desktop |> self.lib.electronFixIME |> self.lib.electronUseGnomeLibsecret)
        obs-studio
        kdePackages.kdenlive
        wl-clipboard
        wakatime-cli
        anki
        thunderbird
        elan
        android-tools
        ffmpeg
        python3
        nodejs
        pnpm
        inputs.llm-agents.packages.x86_64-linux.pi
        self.packages.x86_64-linux.pi-web
        inputs.llm-agents.packages.x86_64-linux.codex
        (inputs.llm-agents.packages.x86_64-linux.chatgpt.overrideAttrs (prev: {
          postFixup = (prev.postFixup or "") + ''
            wrapProgram "$out/bin/chatgpt" \
              --prefix PATH : ${lib.makeBinPath [ bubblewrap ]}
          '';
        }))
        glow
      ];

      programs.alacritty.enable = true;
      programs.dbeaver.enable = true;

      systemd.user.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
}
