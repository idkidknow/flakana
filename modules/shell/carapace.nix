{
  flake.modules.homeManager.common =
    { ... }:
    {
      programs.carapace = {
        enable = true;
        enableNushellIntegration = true;
        enableFishIntegration = false;
      };
    };
}
