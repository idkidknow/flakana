{ inputs, ... }:
{
  flake.modules.nixos."hosts/mizuki" =
    { pkgs, ... }:
    {
      boot.initrd.luks.devices.cryptroot.device =
        "/dev/disk/by-uuid/80bbb86a-91d1-4f98-978d-8d28ca2496ce";
      fileSystems."/".options = [ "x-systemd.device-timeout=infinity" ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
