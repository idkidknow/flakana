{ self, ... }:
{
  flake.modules.homeManager.common-desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.flakana.niri.enable {
        home.packages = [
          self.packages.${pkgs.stdenv.hostPlatform.system}.mark-shot
        ];

        wayland.windowManager.niri.settings.binds = {
          "Pause" = {
            spawn = [ "mark-shot" ];
          };
        };
      };
    };
}
