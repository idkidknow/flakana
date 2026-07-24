{
  flake.modules.nixos."hosts/mutsumi" =
    { config, ... }:
    {
      vaultix.secrets = {
        nix-access-tokens.file = ../../../secrets/nix-access-tokens.age;
        nix-access-tokens.owner = "idkana";
      };

      nix.access-tokens-file = config.vaultix.secrets.nix-access-tokens.path;

      nix.named-substituters = {
        nix-community.enable = true;
        cernet.enable = true;
        garnix.enable = true;
      };

      nix.settings = {
        netrc-file = "/etc/nix/netrc";
      };
    };
}
