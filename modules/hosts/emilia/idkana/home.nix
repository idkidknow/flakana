{ config, ... }:
{
  flake.modules.homeManager."idkana@emilia" =
    { pkgs, ... }:
    {
      imports = [ config.flake.modules.homeManager.common ];

      home.stateVersion = "26.11";
      home.username = "idkana";
      home.homeDirectory = "/home/idkana";

      home.packages = with pkgs; [
        fastfetch
        python3
        nodejs
        pnpm
      ];

      programs.emacs.enable = true;
      services.emacs.enable = true;
    };
}
