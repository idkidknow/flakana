{ inputs, ... }:
{
  flake.modules.nixos.common-desktop =
    { ... }:
    {
      imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];

      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;

        lowLatency.enable = true;
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
