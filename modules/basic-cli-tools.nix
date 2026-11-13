let
  packages =
    pkgs: with pkgs; [
      vim
      wget
      micro
      eza
      fd
      ripgrep
      bat
      less
      bottom
      home-manager
      just
      nh
      gh
      rom
      dix
      tealdeer
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

  flake.modules.systemManager.common =
    { pkgs, ... }:
    {
      environment.systemPackages = packages pkgs;
    };
}
