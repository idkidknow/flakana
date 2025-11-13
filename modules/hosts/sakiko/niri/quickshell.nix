{ inputs, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      home.packages = [
        (inputs.quickshell.packages.x86_64-linux.default.withModules (
          with pkgs.kdePackages;
          [
            qtmultimedia
          ]
        ))
      ];

      programs.niri.settings.environment.QT_FFMPEG_DECODING_HW_DEVICE_TYPES = "cuda";
      programs.niri.settings.spawn-at-startup = [
        {
          argv = [
            "quickshell"
            "-c"
            "kana"
          ];
        }
      ];

      programs.niri.settings.layer-rules = [
        {
          matches = [ { namespace = "^wallpaper$"; } ];
          place-within-backdrop = true;
        }
      ];
    };
}
