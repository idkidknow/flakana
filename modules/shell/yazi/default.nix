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
        version = "0-unstable-2025-02-23";

        src = pkgs.fetchFromGitHub {
          owner = "dangooddd";
          repo = "kanagawa.yazi";
          rev = "31167ed54c9cc935b2fa448d64d367b1e5a1105d";
          hash = "sha256-phwGd1i/n0mZH/7Ukf1FXwVgYRbXQEWlNRPCrmR5uNk=";
        };

        buildPhase = ''
          mkdir $out
          cp -r $src $out/kanagawa.yazi
        '';
      };
    };
}
