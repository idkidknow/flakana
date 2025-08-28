{ inputs, ... }:
{
  flake.modules.nixos.common =
    { lib, config, ... }:
    {
      options = {
        nix.nix-community-cache = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        nix.tuna = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        nix.sjtu = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        nix.garnix = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        nix.nix-on-droid-cache = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        nix.nix-gaming-cache = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        nix.access-tokens-file = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };

      config = {
        nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

        nix.settings = {
          substituters = lib.mkMerge [
            (lib.mkIf config.nix.nix-community-cache [ "https://nix-community.cachix.org" ])
            (lib.mkIf config.nix.tuna [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ])
            (lib.mkIf config.nix.sjtu [ "https://mirror.sjtu.edu.cn/nix-channels/store" ])
            (lib.mkIf config.nix.garnix [ "https://cache.garnix.io" ])
            (lib.mkIf config.nix.nix-on-droid-cache [ "https://nix-on-droid.cachix.org" ])
            (lib.mkIf config.nix.nix-gaming-cache [ "https://nix-gaming.cachix.org" ])
          ];

          experimental-features = [
            "nix-command"
            "flakes"
            "pipe-operators"
          ];

          trusted-public-keys = lib.mkMerge [
            (lib.mkIf config.nix.nix-community-cache [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ])
            (lib.mkIf config.nix.garnix [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ])
            (lib.mkIf config.nix.nix-on-droid-cache [
              "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU="
            ])
            (lib.mkIf config.nix.nix-gaming-cache [
              "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
            ])
          ];
        };
        nix.extraOptions = lib.mkIf (
          config.nix.access-tokens-file != null
        ) "!include ${config.nix.access-tokens-file}";
      };
    };
}
