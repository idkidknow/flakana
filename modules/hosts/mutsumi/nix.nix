{
  flake.modules.nixos.nix-secrets-catalog = {
    security.nix-secrets.secrets.nix-access-tokens.recipients = [ "mutsumi" ];
  };

  flake.modules.nixos."hosts/mutsumi" =
    { config, ... }:
    {
      security.nix-secrets.secrets.nix-access-tokens.owner = "idkana";

      nix.access-tokens-file = config.security.nix-secrets.secrets.nix-access-tokens.path;

      nix.named-substituters = {
        idkidknow.enable = true;
        nix-community.enable = true;
        cernet.enable = true;
      };

      nix.settings = {
        netrc-file = "/etc/nix/netrc";
      };
    };
}
