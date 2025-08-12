{ self, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      home.packages = with pkgs; [
        (self.lib.electronFixIME qq)
        wechat
      ];
    };
}
