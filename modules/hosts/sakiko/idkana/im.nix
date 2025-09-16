{ self, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      home.packages = with pkgs; [
        (self.lib.electronFixIME qq)
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
      ];
    };
}
