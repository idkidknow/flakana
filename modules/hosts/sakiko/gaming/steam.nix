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
      programs.gamescope.enable = true;
    };

  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      wayland.windowManager.niri.settings._children = [
        # do not center notification toasts
        {
          window-rule = {
            match._props = {
              app-id = "^steam$";
              title = "^notificationtoast";
            };
            default-floating-position._props = {
              relative-to = "top-right";
              x = 0;
              y = 0;
            };
            open-focused = false;
          };
        }
      ];
    };
}
