{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      home.packages = with pkgs; [
        (qq.override {
          # Fix the issue that the IME does not work when NIXOS_OZONE_WL=1
          commandLineArgs = "--wayland-text-input-version=3";
        })
        wechat
      ];
    };
}
