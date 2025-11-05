{ inputs, lib, ... }:
{
  options.nixpkgsInstances = lib.mkOption {
    type = lib.types.attrs;
  };

  config.nixpkgsInstances = {
    master-x86_64-linux = import inputs.nixpkgs-master {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  };
}
