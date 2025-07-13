{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      virtualisation.waydroid.enable = true;
      programs.adb.enable = true;
    };
}
