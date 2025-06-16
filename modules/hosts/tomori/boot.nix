{ inputs, ... }:
{
  flake.modules.nixos."hosts/tomori" = {
    # Use the GRUB 2 boot loader.
    boot.loader.grub.enable = true;
    # boot.loader.grub.efiSupport = true;
    # boot.loader.grub.efiInstallAsRemovable = true;
    # boot.loader.efi.efiSysMountPoint = "/boot/efi";
    # Define on which hard drive you want to install Grub.
    # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

    ############### Add by reinstall.sh ###############
    boot.loader.grub.device = "/dev/vda";
    swapDevices = [
      {
        device = "/swapfile";
        size = 69;
      }
    ];
    boot.kernelParams = [
      "console=ttyS0,115200n8"
      "console=tty0"
    ];
    networking = {
      usePredictableInterfaceNames = false;
      interfaces.eth0.ipv6.addresses = [
        {
          address = inputs.priv.tomori-ipv6;
          prefixLength = 128;
        }
      ];
      defaultGateway6 = {
        address = "fe80::feee:ffff:feff:ffff";
        interface = "eth0";
      };
      nameservers = [
        "183.60.83.19"
        "183.60.82.98"
        "2606:4700:4700::1111"
        "2001:4860:4860::8888"
      ];
    };
    boot.kernel.sysctl."net.ipv6.conf.eth0.accept_ra" = false;
    boot.kernel.sysctl."net.ipv6.conf.eth0.autoconf" = false;
    ###################################################
  };
}
