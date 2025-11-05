{ inputs, ... }:
{
  flake.modules.homeManager.common =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.git = {
        enable = true;

        settings = {
          alias = {
            l = "log --graph --oneline --all";
            a = "add";
            c = "commit";
            d = "-c diff.external=${lib.getExe pkgs.difftastic} diff";
          };

          user.email = inputs.priv.email;
          user.name = "idkana";

          init.defaultBranch = "main";
        };
        signing = {
          format = "ssh";
          key = config.home.homeDirectory + "/.ssh/id_ed25519.pub";
          signByDefault = true;
        };
      };
    };
}
