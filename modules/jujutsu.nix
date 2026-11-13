{ config, ... }:
let
  priv = config.priv;
in
{
  flake.modules.homeManager.common =
    { pkgs, lib, ... }:
    {
      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "idkana";
            email = priv.email;
          };
          signing = {
            behavior = "own";
            backend = "ssh";
            key = "~/.ssh/id_ed25519.pub";
          };
          revsets.git-sign-on-push = "~signed() & mine()";
          ui.default-command = "log";
          ui.diff-formatter = [
            "${lib.getExe pkgs.difftastic}"
            "--color=always"
            "$left"
            "$right"
          ];

          aliases = {
            tug = [
              "bookmark"
              "move"
              "--from"
              "heads(::@- & bookmarks())"
              "--to"
              "@-"
            ];
          };
        };
      };

      programs.jjui = {
        enable = true;
      };
    };
}
