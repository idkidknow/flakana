{ inputs, ... }:
{
  flake.modules.homeManager.common =
    { pkgs, lib, config, ... }:
    {
      programs.git = {
        enable = true;

        aliases = {
          l = "log --graph --oneline --all";
          a = "add";
          c = "commit";
          d = "-c diff.external=${lib.getExe pkgs.difftastic} diff";
        };

        userEmail = inputs.priv.email;
        userName = "idkana";

        signing = {
          format = "ssh";
          key = config.home.homeDirectory + "/.ssh/id_ed25519.pub";
          signByDefault = true;
        };

        extraConfig = {
          init.defaultBranch = "main";
        };
      };
    };
}
