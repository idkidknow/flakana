{ inputs, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    let
      quickshell =
        (inputs.quickshell.packages.x86_64-linux.default.override {
          withX11 = false;
        }).overrideAttrs
          (prev: {
            buildInputs = prev.buildInputs ++ [
              pkgs.kdePackages.qtmultimedia
            ];
          });
    in
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      home.packages = [ quickshell ];

      # programs.niri.settings.environment.QT_FFMPEG_DECODING_HW_DEVICE_TYPES = "cuda";
      # programs.niri.settings.spawn-at-startup = [
      #   {
      #     argv = [
      #       "quickshell"
      #       "-c"
      #       "kana"
      #     ];
      #   }
      # ];
      programs.noctalia-shell = {
        enable = true;
        package = inputs.noctalia.packages.x86_64-linux.default.override {
          inherit quickshell;
        };
        systemd.enable = true;

        # settings = builtins.fromJSON (builtins.readFile ./noctalia.json);
      };

      programs.niri.settings.layer-rules = [
        {
          matches = [
            { namespace = "^wallpaper$"; }
            { namespace = "^noctalia-wallpaper"; }
          ];
          place-within-backdrop = true;
        }
      ];

    };
}
