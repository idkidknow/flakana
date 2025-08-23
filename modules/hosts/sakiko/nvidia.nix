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

        # track: https://forums.developer.nvidia.com/t/580-65-06-gtk-4-apps-hang-when-attempting-to-exit-close/341308
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "570.181";
          sha256_64bit = "sha256-8G0lzj8YAupQetpLXcRrPCyLOFA9tvaPPvAWurjj3Pk=";
          sha256_aarch64 = "sha256-1pUDdSm45uIhg0HEhfhak9XT/IE/XUVbdtrcpabZ3KU=";
          openSha256 = "sha256-U/uqAhf83W/mns/7b2cU26B7JRMoBfQ3V6HiYEI5J48=";
          settingsSha256 = "sha256-iBx/X3c+1NSNmG+11xvGyvxYSMbVprijpzySFeQVBzs=";
          persistencedSha256 = "sha256-RoAcutBf5dTKdAfkxDPtMsktFVQt5uPIPtkAkboQwcQ=";
        };
      };
    };
}
