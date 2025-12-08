{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      services.scx = {
        enable = true;
        scheduler = "scx_rusty";
      };
    };
}
