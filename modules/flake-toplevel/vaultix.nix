{ inputs, ... }:
{
  imports = [ inputs.vaultix.flakeModules.default ];

  flake.modules.nixos.common = {
    imports = [ inputs.vaultix.nixosModules.default ];
  };

  flake.vaultix = {
    identity = "/home/idkana/key.txt";
  };
}
