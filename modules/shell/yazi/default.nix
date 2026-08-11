{ self, ... }:
{
  flake.modules.homeManager.common =
    { pkgs, ... }:
    {
      programs.yazi = {
        enable = true;
        plugins = {
          inherit (pkgs.yaziPlugins) git toggle-pane;
        };
        shellWrapperName = "y";
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
      xdg.configFile = {
        "yazi/yazi.toml".source = ./yazi.toml;
        "yazi/theme.toml".source = ./theme.toml;
        "yazi/keymap.toml".source = ./keymap.toml;
        "yazi/init.lua".source = ./init.lua;
        "yazi/flavors/kanagawa.yazi".source = "${
          self.packages.${pkgs.stdenv.hostPlatform.system}.yazi-flavor-kanagawa
        }/kanagawa.yazi";
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.yazi-flavor-kanagawa = pkgs.stdenv.mkDerivation {
        pname = "yazi-flavor-kanagawa";
        version = "0-unstable-2026-08-11";

        src = pkgs.fetchFromGitHub {
          owner = "dangooddd";
          repo = "kanagawa.yazi";
          rev = "04985d12842b06bdb3ad5f1b3d7abc631059b7f5";
          hash = "sha256-Yz0zRVzmgbrk0m7OkItxIK6W0WkPze/t09pWFgziNrw=";
        };

        buildPhase = ''
          mkdir $out
          cp -r $src $out/kanagawa.yazi
        '';
      };
    };
}
