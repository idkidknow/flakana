{ lib, ... }:
let
  info-type = lib.types.submodule {
    options = {
      system = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };
in
{
  options.hosts = lib.mkOption {
    type = lib.types.lazyAttrsOf info-type;
  };
}
