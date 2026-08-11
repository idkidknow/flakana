{
  flake.modules.homeManager.common =
    { ... }:
    {
      programs.nushell = {
        enable = true;
        extraConfig = builtins.readFile ./config.nu;
      };
    };
}
