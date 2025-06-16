{
  flake.modules.nixos.common =
    { lib, config, ... }:
    {
      options = {
        nix.tuna = lib.mkOption {
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
        nix.access-tokens-file = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };

      config = {
        nix.settings = {
          substituters = lib.mkMerge [
            (lib.mkIf config.nix.tuna [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ])
            (lib.mkIf config.nix.garnix [ "https://cache.garnix.io" ])
            (lib.mkIf config.nix.nix-on-droid-cache [ "https://nix-on-droid.cachix.org" ])
          ];
          experimental-features = [
            "nix-command"
            "flakes"
            "pipe-operators"
          ];
          trusted-public-keys = lib.mkIf config.nix.garnix [
            "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
            "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU="
          ];
        };
        nix.extraOptions = lib.mkIf (
          config.nix.access-tokens-file != null
        ) "!include ${config.nix.access-tokens-file}";
      };
    };
}
