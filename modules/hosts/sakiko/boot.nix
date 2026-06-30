{ inputs, ... }:
{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
    };
}
