{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      rust-overlay = import inputs.rust-overlay;
      rust-bin = (pkgs.extend rust-overlay).rust-bin.selectLatestNightlyWith (
        toolchain: toolchain.default
      );
      rustPlatform = pkgs.makeRustPlatform {
        cargo = rust-bin;
        rustc = rust-bin;
      };
    in
    {
      packages.rssbot = rustPlatform.buildRustPackage rec {
        pname = "rssbot";
        version = "2.0.0-alpha.13";
        src = pkgs.fetchFromGitHub {
          owner = "iovxw";
          repo = "rssbot";
          rev = "v${version}";
          hash = "sha256-lo8VQVnNRp6oYK/DTgYBCCqDMYLlNbnZsQtHSgoa5u0=";
          fetchSubmodules = true;
        };
        cargoHash = "sha256-wU4kGSDCZl6nBWJa+5VuOle4L9d5wMD8J3e9s00hLIg=";
      };
    };

  flake.modules.nixos."hosts/tomori" =
    { lib, ... }:
    let
      package = inputs.self.packages.x86_64-linux.rssbot;
      wd = "/var/lib/rssbot";
    in
    {
      users.users.rssbot = {
        description = "rssbot daemon user";
        group = "rssbot";
        isSystemUser = true;
        home = wd;
      };
      users.groups.rssbot = { };

      systemd.tmpfiles.settings."10-rssbot".${wd}.d = {
        user = "rssbot";
        group = "rssbot";
        mode = "700";
      };

      vaultix.secrets.rssbot-dot-env = {
        file = ../../../secrets/rssbot-env.age;
        mode = "400";
        owner = "rssbot";
        group = "rssbot";
        path = "${wd}/.env";
      };

      systemd.services.rssbot = {
        description = "Lightweight Telegram RSS notification bot";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "rssbot";
          Group = "rssbot";
          ExecStart = "${lib.getExe package} --admin $ADMIN $RSSBOT_TOKEN";
          EnvironmentFile = "${wd}/.env";
          WorkingDirectory = wd;
        };
      };
    };
}
