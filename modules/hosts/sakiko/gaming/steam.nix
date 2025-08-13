{
  flake.modules.nixos."hosts/sakiko" =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
      programs.gamemode.enable = true;
    };
}
