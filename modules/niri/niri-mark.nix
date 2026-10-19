{ self, ... }:
{
  flake.modules.homeManager.common-desktop =
    { pkgs, lib, ... }:
    let
      my-scripts = self.packages.${pkgs.stdenv.hostPlatform.system}.my-scripts;
    in
    {
      wayland.windowManager.niri.settings._children = [
        {
          spawn-at-startup = [
            "${my-scripts}/bin/my"
            "niri-mark"
            "daemon"
          ];
        }
      ];
      wayland.windowManager.niri.settings.binds =
        let
          keyMap = {
            "1" = "EIN";
            "2" = "DOS";
            "3" = "TROIS";
            "4" = "NE";
            "5" = "FEM";
            "6" = "LIU";
          };

          mkBind = action: mark: {
            spawn = [
              "${my-scripts}/bin/my"
              "niri-mark"
              action
              mark
            ];
            _props.repeat = false;
          };
        in
        lib.concatMapAttrs (key: mark: {
          "Super+${key}" = mkBind "focus" mark;
          "Super+Ctrl+${key}" = mkBind "mark" mark;
        }) keyMap;
    };
}
