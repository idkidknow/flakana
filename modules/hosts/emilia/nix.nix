{
  flake.modules.systemManager."hosts/emilia" =
    { ... }:
    {
      nix.access-tokens-file = "/home/idkana/nix-access-tokens";
      nix.settings.sandbox = false;
      nix.named-substituters = {
        idkidknow.enable = true;
        numtide.enable = true;
        cernet.enable = true;
        nix-community.enable = true;
      };
    };
}
