{ inputs, ... }:
{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      imports = [ inputs.nix-index-database.nixosModules.nix-index ];
    };
}
