{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      flakana.emacs.enable = true;
      services.emacs.enable = true;
    };
}
