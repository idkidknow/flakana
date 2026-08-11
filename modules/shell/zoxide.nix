{
  flake.modules.homeManager.common =
    { ... }:
    {
      programs.zoxide = {
        enable = true;
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
    };
}
