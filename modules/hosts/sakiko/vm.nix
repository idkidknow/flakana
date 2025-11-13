{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.qemu ];
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;
      users.users.idkana.extraGroups = [ "libvirtd" ];
      networking.firewall.trustedInterfaces = [ "virbr0" ];
    };
}
