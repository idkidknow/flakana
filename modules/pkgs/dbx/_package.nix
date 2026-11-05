{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  wrapGAppsHook3,
  cairo,
  dbus,
  fontconfig,
  gdk-pixbuf,
  glib,
  glib-networking,
  gtk3,
  libayatana-appindicator,
  libsoup_3,
  wayland,
  webkitgtk_4_1,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dbx";
  version = "0.6.66";

  src = fetchurl {
    url = "https://github.com/t8y2/dbx/releases/download/v${finalAttrs.version}/DBX_${finalAttrs.version}_amd64.deb";
    hash = "sha256-RgwmCDV68T/lUkhNWpvuCVO0dxIke8Imbe4YCx5ieRI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    dbus
    fontconfig
    gdk-pixbuf
    glib
    glib-networking
    gtk3
    libsoup_3
    wayland
    webkitgtk_4_1
  ];

  # Tauri loads the tray library with dlopen.
  runtimeDependencies = [ (lib.getLib libayatana-appindicator) ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x "$src" .
    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -r usr/bin usr/share "$out/"
    runHook postInstall
  '';

  meta = {
    description = "Open-source database management tool";
    homepage = "https://github.com/t8y2/dbx";
    changelog = "https://github.com/t8y2/dbx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "dbx";
    platforms = [ "x86_64-linux" ];
  };
})
