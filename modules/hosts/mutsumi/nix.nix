{
  flake.modules.nixos."hosts/mutsumi" =
    { config, ... }:
    {
      vaultix.secrets = {
        nix-access-tokens.file = ../../../secrets/nix-access-tokens.age;
        nix-access-tokens.owner = "idkana";
      };

      nix.access-tokens-file = config.vaultix.secrets.nix-access-tokens.path;
      nix.sjtu = true;
      nix.garnix = true;
      nix.nix-on-droid-cache = true;
    };
}
