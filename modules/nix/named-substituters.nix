let
  named-substituters = {
    idkidknow = {
      url = [ "https://cache.idkidknow.com" ];
      key = [ "idkana:DDvSQjhB+W8jB0DnR+4jEwAh5E4OOcoVhDnwBDe0COo=" ];
    };

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

    ustc = {
      url = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
      key = [ ];
    };

    cernet = {
      url = [ "https://mirrors.cernet.edu.cn/nix-channels/store" ];
      key = [ ];
    };

    nix-on-droid = {
      url = [ "https://nix-on-droid.cachix.org" ];
      key = [ "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU=" ];
    };

    nix-gaming = {
      url = [ "https://nix-gaming.cachix.org" ];
      key = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };

    numtide = {
      url = [ "https://cache.numtide.com" ];
      key = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
    };

    nix-cachyos-kernel = {
      url = [ "https://attic.xuyh0120.win/lantian" ];
      key = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
    };
  };

  module =
    { lib, config, ... }:
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
              keyOnly = lib.mkOption {
                type = lib.types.bool;
                description = "add public keys only";
                default = false;
              };
            }
          );
      };

      config = {
        nix.settings =
          let
            cfg = config.nix.named-substituters;
            substituters =
              named-substituters
              |> lib.mapAttrsToList (name: value: lib.mkIf (cfg.${name}.enable && !cfg.${name}.keyOnly) value.url)
              |> lib.mkMerge;

            trusted-public-keys =
              named-substituters
              |> lib.mapAttrsToList (name: value: lib.mkIf cfg.${name}.enable value.key)
              |> lib.mkMerge;
          in
          {
            inherit substituters trusted-public-keys;
          };
      };
    };
in
{
  flake.modules.nixos.common = module;
  flake.modules.systemManager.common = module;
}
