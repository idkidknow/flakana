{
  inputs,
  lib,
  flake-parts-lib,
  ...
}:
{
  options.perSystem = flake-parts-lib.mkPerSystemOption {
    options.nixpkgsInstances = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.pkgs;
      default = { };
    };
  };

  config.perSystem =
    { config, system, ... }:
    {
      nixpkgsInstances = {
        default = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            inputs.mvn-trace-forge.overlays.default
            (import inputs.rust-overlay)
            inputs.nix-cachyos-kernel.overlays.pinned
          ];
        };

        master = import inputs.nixpkgs-master {
          inherit system;
          config.allowUnfree = true;
          overlays = [ ];
        };
      };

      _module.args.pkgs = config.nixpkgsInstances.default;
    };
}
