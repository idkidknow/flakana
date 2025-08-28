{
  flake.modules.nixos."hosts/sakiko" =
    { config, ... }:
    {
      vaultix.secrets = {
        nix-access-tokens.file = ../../../secrets/nix-access-tokens.age;
        nix-access-tokens.owner = "idkana";
      };

      nix.access-tokens-file = config.vaultix.secrets.nix-access-tokens.path;
      nix.nix-community-cache = true;
      nix.sjtu = true;
      nix.garnix = true;
      nix.nix-on-droid-cache = true;
    };
}
