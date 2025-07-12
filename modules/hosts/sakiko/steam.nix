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
}
