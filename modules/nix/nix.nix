{ inputs, self, ... }:
{
  flake.modules.nixos.common =
    { lib, config, ... }:
    {
      options = {
        nix.access-tokens-file = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };

      config = {
        nix.nixPath = [
          "nixpkgs=${inputs.nixpkgs}"
          "flakana=${self}"
        ];

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
}
