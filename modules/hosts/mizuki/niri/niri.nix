{
  flake.modules.nixos."hosts/mizuki" = { ... }: {
    flakana.niri.enable = true;
  };

  flake.modules.homeManager."idkana@mizuki" = { ... }: {
    flakana.niri.enable = true;
  };
}
