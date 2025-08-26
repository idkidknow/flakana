{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    let
      layer-shell-cage = pkgs.cage.overrideAttrs (prev: {
        src = pkgs.fetchFromGitHub {
          owner = "idkidknow";
          repo = "layer-shell-cage";
          rev = "ee2e92072241da612e70c9b13a2e828836707108";
          hash = "sha256-gl141Zz3rCoFW/LfU0Gw/Mk+kKJU+TorkC3RYgxLW98=";
        };

        buildInputs = (builtins.filter (p: p != pkgs.wlroots_0_18) prev.buildInputs) ++ [
          pkgs.wlr-protocols
          pkgs.wlroots_0_19
        ];
      });
    in
    {
      home.packages = [
        (pkgs.writeShellScriptBin "my-wallpaper" ''
          exec ${pkgs.lib.getExe layer-shell-cage} -l background -o "$1" -z -1 -n wallpaper -- \
            ${pkgs.lib.getExe pkgs.mpv} "$2" \
            --no-audio --loop-playlist --hwdec=auto --gpu-api=vulkan --fullscreen --no-config
        '')
      ];
    };
}
