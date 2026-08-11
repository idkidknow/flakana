{
  inputs,
  config,
  self,
  ...
}:
let
  # new nixpkgs has moved `nix.enable` and `nix.package`
  # from `nix-daemon.nix` to `config/nix.nix`
  # and started referencing `programs.bash.completion.enable`
  # and `services.displayManager.hiddenUsers`
  # track: ?
  system-manager-nix-nix-patched =
    {
      config,
      lib,
      nixosModulesPath,
      ...
    }:
    {
      options = {
        programs.bash.completion.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };

      imports = [
        (nixosModulesPath + "/services/display-managers/default.nix")
        (nixosModulesPath + "/services/display-managers/generic.nix")
        {
          disabledModules = [
            "${inputs.system-manager.outPath}/nix/modules/upstream/nixpkgs/nix.nix"
          ];
        }
      ];

      config = lib.mkIf config.nix.enable {
        environment.etc."nix/nix.conf".replaceExisting = true;
        nix.settings.experimental-features = lib.mkDefault [
          "nix-command"
          "flakes"
        ];
      };
    };
in
{
  flake.modules.systemManager."hosts/emilia" =
    { pkgs, ... }:
    {
      nixpkgs.hostPlatform = "aarch64-linux";

      imports = [
        config.flake.modules.systemManager.common
        system-manager-nix-nix-patched
      ];

      environment.systemPackages = with pkgs; [
        inputs.system-manager.packages.aarch64-linux.default
        nixfmt
        nixd
      ];

      systemd.services = { };

      environment.sessionVariables.NIX_PATH = [
        "nixpkgs=${inputs.nixpkgs}"
        "flakana=${self}"
      ];
    };
}
