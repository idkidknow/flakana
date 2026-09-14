{ config, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      home.packages = with pkgs; [
        qq
        telegram-desktop
        wechat
      ];

      wayland.windowManager.niri.settings._children = [
        {
          window-rule = {
            match._props = {
              app-id = "^org\.telegram\.desktop$";
              title = "媒体查看器";
            };
            open-floating = true;
          };
        }
        {
          window-rule._children = [
            {
              match._props = {
                app-id = "^QQ$";
                title = "^图片查看器$";
              };
            }
            {
              match._props = {
                app-id = "^QQ$";
                title = "的聊天记录$";
              };
            }
            { open-floating = true; }
            { default-column-width.fixed = 600; }
            { default-window-height.fixed = 900; }
          ];
        }
        {
          window-rule = {
            match._props = {
              app-id = "^QQ$";
              title = "视频播放器";
            };
            open-floating = true;
          };
        }
      ];
    };
}
