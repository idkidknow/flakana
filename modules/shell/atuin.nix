{
  flake.modules.homeManager.common =
    { ... }:
    {
      programs.atuin = {
        enable = true;
        flags = [ "--disable-up-arrow" ];
        settings = {
          filter_mode = "session-preload";
          search.shells = "all";
        };
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
    };
}
