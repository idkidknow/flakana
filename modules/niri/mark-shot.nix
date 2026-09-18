{ inputs, ... }:
{
  flake.modules.homeManager.common-desktop =
    { config, lib, ... }:
    {
      config = lib.mkIf config.flakana.niri.enable {
        home.packages = [
          inputs.mark-shot.packages.x86_64-linux.default
        ];

        wayland.windowManager.niri.settings.binds = {
          "Pause" = {
            spawn = [ "mark-shot" ];
          };
        };
      };
    };
}
