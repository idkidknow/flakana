{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      powerManagement.enable = true;
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;

      # Razer mouse
      services.udev.extraRules = ''
        ACTION=="add|change", SUBSYSTEM=="usb", DRIVERS=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="0084", ATTR{power/wakeup}="disabled"
      '';
    };
}
