{ self, ... }:
{
  flake.modules.nixos."hosts/tomori" = {
    environment.systemPackages = [ self.packages.x86_64-linux.somo ];
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.somo = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "somo";
        version = "1.0.0";
        src = pkgs.fetchFromGitHub {
          owner = "theopfr";
          repo = "somo";
          tag = "v${finalAttrs.version}";
          hash = "sha256-MPeUR2a3TQUowFd0TadvGz0f1MwWB2tc047F9Ricp0I=";
        };

        cargoHash = "sha256-uYC0GOnzo8nQ8uo7CP3snBnoSOHPE7iYcC6HLUM4SiE=";
      });
    };
}
