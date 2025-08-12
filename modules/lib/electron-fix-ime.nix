{
  flake.lib.electronFixIME =
    pkg:
    pkg.override {
      # niri doesn't support v1
      commandLineArgs = "--wayland-text-input-version=3";
    };
}
