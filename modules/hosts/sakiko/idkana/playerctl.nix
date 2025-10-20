{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      services.playerctld = {
        enable = true;
      };
    };
}
