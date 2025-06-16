{ lib, ... }:
{
  options.flake.deploy.nodes = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.attrs;
    default = { };
  };
}
