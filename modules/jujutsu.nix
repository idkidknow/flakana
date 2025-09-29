{ inputs, ... }:
{
  flake.modules.homeManager.common =
    { pkgs, lib, ... }:
    {
      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "idkana";
            email = inputs.priv.email;
          };
          signing = {
            behavior = "own";
            backend = "ssh";
            key = "~/.ssh/id_ed25519.pub";
          };
          git.sign-on-push = true;
          ui.default-command = "log";
          ui.diff-formatter = [
            "${lib.getExe pkgs.difftastic}"
            "--color=always"
            "$left"
            "$right"
          ];
        };
      };
    };
}
