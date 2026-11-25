{
  flake.modules.nixos.nix-secrets-catalog = {
    security.nix-secrets.secrets.xray-json.recipients = [ "tomori" ];
  };

  flake.modules.nixos."hosts/tomori" =
    { config, ... }:
    {
      security.nix-secrets.secrets.xray-json = { };

      services.xray = {
        enable = true;
        settingsFile = config.security.nix-secrets.secrets.xray-json.path;
      };
    };
}
