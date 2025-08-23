{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, lib, ... }:
    {
      services.greetd =
        let
          settings = {
            GTK = {
              application_prefer_dark_theme = true;
              theme_name = "Breeze-Dark";
              cursor_theme_name = "breeze_cursors";
            };
          };
          settingsToml = (pkgs.formats.toml { }).generate "regreet.toml" settings;
        in
        {
          enable = true;
          settings = {
            default_session = {
              command = "${lib.getExe pkgs.cage} -s -m last -- ${lib.getExe pkgs.regreet} --config ${settingsToml}";
              user = "greeter";
            };
          };
        };

      users.users.greeter = {
        description = "greeter";
        group = "greeter";
        isSystemUser = true;
      };
      users.groups.greeter = { };
      systemd.tmpfiles.settings."10-regreet" = {
        "/var/log/regreet".d = {
          user = "greeter";
          group = "greeter";
          mode = "0755";
        };
        "/var/lib/regreet".d = {
          user = "greeter";
          group = "greeter";
          mode = "0755";
        };
      };
    };
}
