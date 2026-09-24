{ inputs, ... }:
{
  flake.modules.homeManager."idkana@sakiko" = { ... }: {
    home.packages = [
      inputs.nix-gaming.packages.x86_64-linux.osu-lazer-bin
    ];
  };
}
