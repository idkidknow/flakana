{ inputs, ... }:
{
  flake.modules.homeManager."idkana@mutsumi" =
    { ... }:
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
        };
      };
    };
}
