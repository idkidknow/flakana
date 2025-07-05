{
  flake.modules.homeManager.common =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        jetbrains-mono
        nerd-fonts.jetbrains-mono
        lxgw-neoxihei
        hanazono
      ];
    };
}
