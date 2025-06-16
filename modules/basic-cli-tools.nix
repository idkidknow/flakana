let
  packages =
    pkgs: with pkgs; [
      git
      vim
      wget
      micro
      eza
      fd
      ripgrep
      bat
    ];
in
{
  flake.modules.nixos.common =
    { pkgs, ... }:
    {
      environment.systemPackages = packages pkgs;
    };

  flake.modules.homeManager.common =
    { pkgs, ... }:
    {
      home.packages = packages pkgs;
    };
}
