{
  flake.modules.nixos."hosts/sakiko" = { ... }: {
    flakana.niri.enable = true;
  };

  flake.modules.homeManager."idkana@sakiko" = { ... }: {
    flakana.niri.enable = true;
  };
}
