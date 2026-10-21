{ withSystem, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    let
      pkgs-master = withSystem pkgs.stdenv.hostPlatform.system (
        { config, ... }: config.nixpkgsInstances.master
      );
    in
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

      wayland.windowManager.niri.settings._children = [
        {
          window-rule = {
            match._props.app-id = "^Minecraft";
            open-maximized = true;
            variable-refresh-rate = true;
          };
        }
      ];
    };
}
