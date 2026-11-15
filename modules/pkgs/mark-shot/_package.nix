{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  autoAddDriverRunpath,
  dpkg,
  makeWrapper,
  fontconfig,
  libgbm,
  libpulseaudio,
  libva,
  libxcb,
  libxkbcommon,
  openssl,
  pipewire,
}:

let
  sources = {
    x86_64-linux = {
      arch = "amd64";
      hash = "sha256-h9SsVtmnWDpCLCIFhvBkW3OQpkswOmQiHc5Ufz9WjVI=";
    };
    aarch64-linux = {
      arch = "arm64";
      hash = "sha256-Jeb/tUQPNr21YYNL2xmBXDVyT7I8QhFexHZSf+KPz0c=";
    };
  };
  source = sources.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mark-shot";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/jswysnemc/mark-shot/releases/download/v${finalAttrs.version}/mark-shot_${finalAttrs.version}-1_${source.arch}.deb";
    inherit (source) hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    autoAddDriverRunpath
    dpkg
    makeWrapper
  ];

  buildInputs = [
    fontconfig
    libgbm
    libva
    libxcb
    libxkbcommon
    openssl
    pipewire
    stdenv.cc.cc.lib
  ];

  # The recording library loads PulseAudio with dlopen.
  appendRunpaths = [ (lib.makeLibraryPath [ libpulseaudio ]) ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r usr/lib usr/share "$out/"
    # The OCR runtime is downloaded on demand and needs libstdc++.
    makeWrapper "$out/lib/mark-shot/mark-shot" "$out/bin/mark-shot" \
      --prefix PATH : ${lib.makeBinPath [ fontconfig ]} \
      --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}

    runHook postInstall
  '';

  meta = {
    description = "Screenshot, annotation, and screen recording tool";
    homepage = "https://github.com/jswysnemc/mark-shot";
    changelog = "${finalAttrs.meta.homepage}/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "mark-shot";
    platforms = builtins.attrNames sources;
  };
})
