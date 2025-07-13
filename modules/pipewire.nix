{
  flake.modules.nixos.common-desktop =
    { ... }:
    {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };

  flake.modules.homeManager.common-desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        helvum
        easyeffects
      ];
    };
}
