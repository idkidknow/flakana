{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      programs.emacs.enable = true;
      services.emacs.enable = true;
    };
}
