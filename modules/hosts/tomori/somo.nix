{ inputs, self, ... }:
{
  flake.modules.nixos."hosts/tomori" = {
    environment.systemPackages = [ self.packages.x86_64-linux.somo ];
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.somo =
        let
          version = "1.0.0";
          src = pkgs.fetchFromGitHub {
            owner = "theopfr";
            repo = "somo";
            tag = "v${version}";
            hash = "sha256-MPeUR2a3TQUowFd0TadvGz0f1MwWB2tc047F9Ricp0I=";
          };
          naersk' = pkgs.callPackage inputs.naersk { };
        in
        naersk'.buildPackage {
          src = src;
        };
    };
}
