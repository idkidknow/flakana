{
  flake.modules.nixos."hosts/sakiko" = { ... }: {
    flakana.niri.enable = true;
  };

  flake.modules.homeManager.common-desktop = { ... }: {
    flakana.niri.enable = true;
  };
}
