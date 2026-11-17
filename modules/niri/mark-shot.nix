{ inputs, ... }:
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
          inputs.mark-shot.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];

        wayland.windowManager.niri.settings.binds = {
          "Pause" = {
            spawn = [ "mark-shot" ];
          };
        };
      };
    };
}
