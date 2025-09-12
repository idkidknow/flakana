{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      nixpkgs.config.allowUnfree = true;
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        open = true;
        powerManagement.enable = true;
      };
    };
}
