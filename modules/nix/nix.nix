{ inputs, self, ... }:
let
  module =
    { lib, config, ... }:
    {
      options = {
        nix.access-tokens-file = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };

      config = {
        nix.settings = {
          experimental-features = [
            "nix-command"
            "flakes"
            "pipe-operators"
          ];
        };

        nix.extraOptions = lib.mkIf (
          config.nix.access-tokens-file != null
        ) "!include ${config.nix.access-tokens-file}";
      };
    };
in
{
  flake.modules.nixos.common =
    { ... }:
    {
      imports = [ module ];
      nix.nixPath = [
        "nixpkgs=${inputs.nixpkgs}"
        "flakana=${self}"
      ];
    };

  flake.modules.systemManager.common = { ... }: {
    imports = [ module ];
    nix.enable = true;
  };
}
