{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      services.mihomo = {
        enable = true;
        configFile = "/etc/mihomo/config.yaml";
        webui = pkgs.metacubexd;
        tunMode = true;
      };
    };
}
