{ inputs, ... }:
{
  flake.modules.nixos."hosts/tomori" =
    { config, ... }:
    {
      vaultix.secrets = {
        nix-access-tokens.file = ../../../secrets/nix-access-tokens.age;
        nix-access-tokens.owner = "idkana";
      };

      nix.access-tokens-file = config.vaultix.secrets.nix-access-tokens.path;
      nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      nix.garnix = true;
    };
}
