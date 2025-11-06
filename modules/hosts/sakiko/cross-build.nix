{
  flake.modules.nixos."hosts/sakiko" = {
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
