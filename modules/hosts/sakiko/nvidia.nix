{
  flake.modules.nixos."hosts/sakiko" =
    { config, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        open = true;
        powerManagement.enable = true;

        # track: https://forums.developer.nvidia.com/t/580-release-feedback-discussion/341205
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "580.82.09";
          sha256_64bit = "sha256-Puz4MtouFeDgmsNMKdLHoDgDGC+QRXh6NVysvltWlbc=";
          sha256_aarch64 = "sha256-6tHiAci9iDTKqKrDIjObeFdtrlEwjxOHJpHfX4GMEGQ=";
          openSha256 = "sha256-YB+mQD+oEDIIDa+e8KX1/qOlQvZMNKFrI5z3CoVKUjs=";
          settingsSha256 = "sha256-um53cr2Xo90VhZM1bM2CH4q9b/1W2YOqUcvXPV6uw2s=";
          persistencedSha256 = "sha256-lbYSa97aZ+k0CISoSxOMLyyMX//Zg2Raym6BC4COipU=";
        };
      };
    };
}
