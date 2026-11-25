{
  flake.modules.nixos.nix-secrets-catalog = {
    security.nix-secrets.secrets.nix-access-tokens.recipients = [ "tomori" ];
  };

  flake.modules.nixos."hosts/tomori" =
    { config, ... }:
    {
      security.nix-secrets.secrets.nix-access-tokens.owner = "idkana";

      nix.access-tokens-file = config.security.nix-secrets.secrets.nix-access-tokens.path;

      nix.named-substituters = {
        idkidknow.enable = true;
        nix-community.enable = true;
      };
    };
}
