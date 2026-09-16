{
  flake.modules.nixos."hosts/mizuki" = { ... }: {
    # https://github.com/hyprwm/Hyprland/discussions/12966
    nixpkgs.overlays = [
      (final: prev: {
        wlroots_0_20 = prev.wlroots_0_20.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./wlroots-vmwgfx-dmabuf.patch ];
        });
      })
    ];
  };
}
