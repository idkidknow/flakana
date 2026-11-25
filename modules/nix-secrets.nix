{
  config,
  inputs,
  lib,
  self,
  ...
}:
let
  storage = ../private-modules/secrets;
  cliFor = pkgs: self.packages.${pkgs.stdenv.hostPlatform.system}.nix-secrets;
in
{
  flake.nixSecretsConfigurations = lib.genAttrs config.systems (
    system:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.nix-secrets.nixosModules.default
        config.flake.modules.nixos.nix-secrets-catalog
      ];
    }
  );

  flake.modules.nixos.nix-secrets-catalog = {
    security.nix-secrets = {
      inherit storage;
      storagePath = "/home/idkana/flakana-priv/private-modules/secrets";
      enable = true;
      activate.enable = false;
      defaultRecipients = [ "master" ];
      identityPaths = [
        "/home/idkana/key.txt"
        "/etc/ssh/ssh_host_ed25519_key"
      ];
    };
  };

  perSystem =
    { pkgs, system, ... }:
    let
      upstream = inputs.nix-secrets.packages.${system}.nix-secrets;
    in
    {
      packages.nix-secrets = pkgs.symlinkJoin {
        inherit (upstream) pname version meta;
        paths = [ upstream ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram "$out/bin/nix-secrets" --run ${lib.escapeShellArg ''
            checkout="''${FLAKANA_PRIVATE_FLAKE:-$HOME/flakana-priv}"
            set -- --module-system nixSecretsConfigurations --flake "$checkout#${system}" "$@"
          ''}
        '';
      };
    };

  flake.modules.nixos.common =
    { config, pkgs, ... }:
    let
      cfg = config.security.nix-secrets;
    in
    {
      imports = [ inputs.nix-secrets.nixosModules.default ];
      security.nix-secrets = {
        inherit storage;
        enable = true;
        package = cliFor pkgs;
        checks.missingSecrets.enable = lib.mkDefault false;
        identityPaths = lib.mkDefault [ "/etc/ssh/ssh_host_ed25519_key" ];
      };
      systemd.services.nix-secrets-activate.before = lib.mkIf (
        cfg.enable && cfg.activate.enable && cfg.activate.method == "systemd"
      ) [ "sysinit.target" ];
    };
}
