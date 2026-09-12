{
  flake.modules.nixos."hosts/mizuki" =
    { config, ... }:
    {
      vaultix.secrets = {
        nix-access-tokens.file = ../../../secrets/nix-access-tokens.age;
        nix-access-tokens.owner = "idkana";
      };

      nix.access-tokens-file = config.vaultix.secrets.nix-access-tokens.path;

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
