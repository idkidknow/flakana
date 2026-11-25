{
  flake.modules.nixos.nix-secrets-catalog = {
    security.nix-secrets.secrets.nix-access-tokens.recipients = [ "mizuki" ];
  };

  flake.modules.nixos."hosts/mizuki" =
    { config, ... }:
    {
      security.nix-secrets.secrets.nix-access-tokens.owner = "idkana";

      nix.access-tokens-file = config.security.nix-secrets.secrets.nix-access-tokens.path;

      nix.named-substituters = {
        idkidknow.enable = true;
        nix-community.enable = true;
        numtide.enable = true;
        cernet.enable = true;
      };

      nix.settings.trusted-users = [
        "root"
        "idkana"
      ];
    };
}
