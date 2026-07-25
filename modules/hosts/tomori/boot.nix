{ ... }:
{
  flake.modules.nixos."hosts/tomori" = {
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/vda";
    swapDevices = [
      {
        device = "/swapfile";
        size = 6 * 1024;
      }
    ];
    boot.kernelParams = [
      "console=ttyS0,115200n8"
      "console=tty0"
    ];
    networking = {
      usePredictableInterfaceNames = false;
      interfaces.eth0.useDHCP = true;
    };
  };
}
