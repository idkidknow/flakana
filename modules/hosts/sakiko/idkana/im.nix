{ config, ... }:
let
  pkgs-master = config.nixpkgsInstances.master-x86_64-linux;
in
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      home.packages = with pkgs; [
        pkgs-master.qq # track: PR #548395
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
