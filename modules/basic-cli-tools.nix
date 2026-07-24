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
      less
      bottom
      home-manager
      just
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
