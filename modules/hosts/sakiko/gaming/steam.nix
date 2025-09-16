{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
      programs.gamemode.enable = true;
    };

  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      programs.niri.settings.window-rules = [
        # do not center notification toasts
        {
          matches = [
            {
              app-id = "^steam$";
              title = "^notificationtoast";
            }
          ];
          default-floating-position = {
            relative-to = "top-right";
            x = 0;
            y = 0;
          };
        }
      ];
    };
}
