{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      # boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.kernelPackages = pkgs.linuxPackages_6_18; # track: https://github.com/NixOS/nixpkgs/issues/489947
    };
}
