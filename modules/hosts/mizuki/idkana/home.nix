{ inputs, config, ... }:
{
  flake.modules.homeManager."idkana@mizuki" =
    { pkgs, ... }:
    {
      imports = [
        config.flake.modules.homeManager.common
        config.flake.modules.homeManager.common-desktop
        inputs.niri-flake.homeModules.niri
      ];

      home.stateVersion = "26.11";
      home.username = "idkana";
      home.homeDirectory = "/home/idkana";

      home.packages = with pkgs; [
        fastfetch
        python3
        nodejs
        pnpm
        glow
      ];

      programs.emacs.enable = true;
      services.emacs.enable = true;

      programs.alacritty.enable = true;

      systemd.user.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
}
