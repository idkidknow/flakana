{ self, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      home.packages =
        let
          # track: ?
          qq-wl = (self.lib.electronFixIME pkgs.qq).override (prev: {
            commandLineArgs = "${prev.commandLineArgs or ""} --ozone-platform=wayland";
          });
        in
        with pkgs;
        [
          qq-wl
          telegram-desktop
          wechat
        ];

      programs.niri.settings.window-rules = [
        {
          matches = [
            {
              app-id = "^org\.telegram\.desktop$";
              title = "媒体查看器";
            }
          ];
          open-floating = true;
        }
        {
          matches = [
            {
              app-id = "^QQ$";
              title = "^图片查看器$";
            }
            {
              app-id = "^QQ$";
              title = "的聊天记录$";
            }
          ];
          open-floating = true;
          default-column-width.fixed = 600;
          default-window-height.fixed = 900;
        }
        {
          matches = [
            {
              app-id = "^QQ$";
              title = "视频播放器";
            }
          ];
          open-floating = true;
        }
      ];
    };
}
