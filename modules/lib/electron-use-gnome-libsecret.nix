{
  flake.lib.electronUseGnomeLibsecret =
    pkg:
    pkg.override (prev: {
      commandLineArgs = "${prev.commandLineArgs or ""} --password-store=\"gnome-libsecret\"";
    });
}
