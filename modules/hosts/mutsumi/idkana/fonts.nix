{
  flake.modules.homeManager."idkana@mutsumi" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        jetbrains-mono
        nerd-fonts.jetbrains-mono
        lxgw-neoxihei
      ];
    };
}
