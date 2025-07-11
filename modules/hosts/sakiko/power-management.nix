{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      powerManagement.enable = true;
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;
    };
}
