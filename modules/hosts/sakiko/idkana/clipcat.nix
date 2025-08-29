{ inputs, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      services.clipcat = {
        enable = true;
        package = inputs.clipcat.packages.x86_64-linux.default;
        enableSystemdUnit = true;
        daemonSettings = {
          daemonize = true;
          max_history = 100;
          log = {
            emit_journald = true;
            level = "INFO";
          };
          watcher = {
            enable_clipboard = true;
            enable_primary = true;
            capture_image = true;
          };
          desktop_notification.enable = false;
        };
        ctlSettings = {
          server_endpoint = "/run/user/1000/clipcat/grpc.sock";
          preview_length = 100;
        };
        menuSettings = {
          server_endpoint = "/run/user/1000/clipcat/grpc.sock";
          finder = "rofi";
          preview_length = 100;
          rofi = {
            line_length = 120;
            menu_length = 25;
            menu_prompt = "Clipcat";
            extra_arguments = [];
          };
        };
      };
    };
}
