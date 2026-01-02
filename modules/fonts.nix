{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.bookerly = pkgs.stdenvNoCC.mkDerivation {
        pname = "bookerly";
        version = "2020.03";
        src = pkgs.fetchzip {
          url = "https://m.media-amazon.com/images/G/01/mobile-apps/dex/alexa/branding/Amazon_Typefaces_Complete_Font_Set_Mar2020.zip";
          hash = "sha256-CK7WSXkJkcwMxwdeW31Zs7p2VdZeC3xbpOnmd6Rr9go=";
        };
        installPhase = ''
          runHook preInstall

          install -Dm644 Bookerly/*.ttf -t $out/share/fonts/truetype
          install -Dm644 'Bookerly Display'/*.ttf -t $out/share/fonts/truetype

          runHook postInstall
        '';
      };
    };

  flake.modules.nixos.common-desktop =
    { pkgs, ... }:
    {
      fonts = {
        packages = with pkgs; [
          open-sans
          self.packages.${pkgs.stdenv.hostPlatform.system}.bookerly
          jetbrains-mono
          nerd-fonts.jetbrains-mono
          nerd-fonts.symbols-only
          lxgw-neoxihei
          lxgw-wenkai
          hanazono
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-color-emoji
        ];
        enableDefaultPackages = true;
        enableGhostscriptFonts = true;

        fontconfig = {
          enable = true;
          defaultFonts = {
            serif = [
              "Bookerly"
              "LXGW WenKai"
              "Noto Serif CJK SC"
              "Noto Serif CJK TC"
              "Noto Serif CJK JP"
              "Noto Serif CJK KR"
              "Noto Serif CJK HK"
              "HanaMinB"
              "Symbols Nerd Font"
            ];
            sansSerif = [
              "Open Sans"
              "LXGW Neo XiHei"
              "Noto Sans CJK SC"
              "Noto Sans CJK TC"
              "Noto Sans CJK JP"
              "Noto Sans CJK KR"
              "Noto Sans CJK HK"
              "HanaMinB"
              "Symbols Nerd Font"
            ];
            monospace = [
              "JetBrains Mono"
              "LXGW Neo XiHei"
              "Noto Sans CJK SC"
              "Noto Sans CJK TC"
              "Noto Sans CJK JP"
              "Noto Sans CJK KR"
              "Noto Sans CJK HK"
              "HanaMinB"
              "Symbols Nerd Font Mono"
            ];
            emoji = [
              "Noto Color Emoji"
            ];
          };
        };

        fontDir.enable = true;
        fontDir.decompressFonts = true;
      };
    };

  flake.modules.homeManager.common-desktop =
    { ... }:
    {
      fonts.fontconfig.enable = true;
    };
}
