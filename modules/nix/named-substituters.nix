{
  flake.modules.nixos.common =
    { lib, config, ... }:
    let
      cfg = config.nix.named-substituters;

      named-substituters = {
        nix-community = {
          url = [ "https://nix-community.cachix.org" ];
          key = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
        };

        tuna = {
          url = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
          key = [ ];
        };

        sjtu = {
          url = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
          key = [ ];
        };

        garnix = {
          url = [ "https://cache.garnix.io" ];
          key = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
        };

        nix-on-droid = {
          url = [ "https://nix-on-droid.cachix.org" ];
          key = [ "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU=" ];
        };

        nix-gaming = {
          url = [ "https://nix-gaming.cachix.org" ];
          key = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
        };
      };

      substituters =
        named-substituters
        |> lib.mapAttrsToList (name: value: lib.mkIf cfg.${name}.enable value.url)
        |> lib.mkMerge;

      trusted-public-keys =
        named-substituters
        |> lib.mapAttrsToList (name: value: lib.mkIf cfg.${name}.enable value.key)
        |> lib.mkMerge;
    in
    {
      options = {
        nix.named-substituters =
          named-substituters
          |> lib.mapAttrs (
            name: value: {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
            }
          );
      };

      config = {
        nix.settings = {
          inherit substituters trusted-public-keys;
        };
      };
    };
}
