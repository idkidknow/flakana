{ self, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.open-orpheus ];
    };

  perSystem =
    { pkgs, ... }:
    let
      inherit (pkgs)
        lib
        stdenv
        fetchurl
        binutils
        zstd
        patchelf
        ;
    in
    {
      packages.open-orpheus = stdenv.mkDerivation rec {
        pname = "open-orpheus";
        version = "0.13.0";
        src = fetchurl {
          url = "https://github.com/YUCLing/open-orpheus/releases/download/v${version}/open-orpheus_${version}_amd64.deb";
          hash = "sha256-dMuX44VViBMw2DjOumSusBxkmoL3Bc+y5z360FkYsR4=";
        };

        nativeBuildInputs = [
          binutils
          zstd
          patchelf
        ];

        buildInputs = with pkgs; [
          gtk3
          libnotify
          nss
          xdg-utils
          at-spi2-core
          libdrm
          mesa
          libxcb
          glib
          nspr
          cups
          dbus
          cairo
          pango
          libX11
          libXcomposite
          libXdamage
          libXext
          libXfixes
          libXrandr
          libgbm
          expat
          libxkbcommon
          udev
          alsa-lib
        ];

        unpackPhase = ''
          runHook preUnpack

          ar vx $src
          tar -xvf data.tar.zst

          runHook postUnpack
        '';
        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          cp -r usr/share $out/
          patchelf \
            --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "${lib.makeLibraryPath buildInputs}:$out/lib/open-orpheus" \
            usr/lib/open-orpheus/open-orpheus
          cp -r usr/lib $out/
          ln -s $out/lib/open-orpheus/open-orpheus $out/bin/open-orpheus

          runHook postInstall
        '';
      };
    };
}
