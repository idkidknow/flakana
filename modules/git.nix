{ inputs, ... }:
{
  flake.modules.homeManager.common =
    { config, ... }:
    {
      programs.git = {
        enable = true;

        aliases = {
          l = "log --graph --oneline --all";
          a = "add";
          c = "commit";
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
