{
  flake.modules.homeManager.common =
    { ... }:
    {
      programs.pay-respects = {
        enable = true;
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
    };
}
