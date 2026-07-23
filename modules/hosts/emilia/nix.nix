{
  flake.modules.systemManager."hosts/emilia" =
    { ... }:
    {
      nix.access-tokens-file = "/home/idkana/nix-access-tokens";
      nix.named-substituters = {
        numtide.enable = true;
        nix-community.enable = true;
      };
    };
}
