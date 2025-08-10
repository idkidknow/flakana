{ self, ... }:
{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      nixpkgs.config.allowUnfree = true;
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
      programs.gamemode.enable = true;
    };

  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      programs.lutris = {
        enable = true;
        steamPackage = self.nixosConfigurations.sakiko.config.programs.steam.package;
        protonPackages = [ pkgs.proton-ge-bin ];
      };
    };
}
