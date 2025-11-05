{ config, ... }:
let
  pkgs-master = config.nixpkgsInstances.master-x86_64-linux;
in
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (pkgs-master.hmcl.override {
          hmclJdk = jdk25;
          minecraftJdks = [
            jdk8
            jdk17
            jdk21
            jdk25
          ];
        })
        prismlauncher
      ];

      programs.niri.settings.window-rules = [
        {
          matches = [ { app-id = "^Minecraft"; } ];
          open-maximized = true;
          variable-refresh-rate = true;
        }
      ];
    };
}
