{
  flake.lib.electronFixIME =
    pkg:
    pkg.override (prev: {
      # niri doesn't support v1
      commandLineArgs = "${prev.commandLineArgs or ""} --wayland-text-input-version=3";
    });
}
