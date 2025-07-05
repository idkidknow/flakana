{ config, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      imports = [ config.flake.modules.homeManager.common ];

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
        tldr
        nix-output-monitor
        nh
      ];
    };
}
