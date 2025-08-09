{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      hardware.opentabletdriver.enable = true;
    };
}
