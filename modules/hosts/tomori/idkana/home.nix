{ config, ... }:
{
  flake.modules.homeManager."idkana@tomori" =
    { pkgs, ... }:
    {
      imports = [ config.flake.modules.homeManager.common ];

      home.username = "idkana";
      home.homeDirectory = "/home/idkana";
      home.packages = with pkgs; [
        starship
        carapace
        zoxide
        jujutsu
        gh
      ];

      home.stateVersion = "24.11";

      programs.home-manager.enable = true;
    };
}
