{
  flake.modules.nixos."hosts/tomori" =
    { config, ... }:
    {
      vaultix.secrets.xray-json = {
        file = ../../../secrets/xray-json.age;
        mode = "400";
        owner = "xray";
        group = "xray";
      };

      services.xray = {
        enable = true;
        settingsFile = config.vaultix.secrets.xray-json.path;
      };
    };
}
