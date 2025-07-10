{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      services.mihomo = {
        enable = true;
        configFile = "/etc/mihomo/config.yaml";
        tunMode = true;
      };
    };
}
