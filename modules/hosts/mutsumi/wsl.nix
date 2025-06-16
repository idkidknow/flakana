{ inputs, ... }:
{
  flake.modules.nixos."hosts/mutsumi" =
    { config, ... }:
    {
      imports = [
        inputs.nixos-wsl.nixosModules.default
      ];

      wsl.enable = true;
      wsl.defaultUser = "idkana";
      wsl.interop.includePath = false;
      wsl.useWindowsDriver = true;
      wsl.wslConf.network.hostname = config.networking.hostName;
    };
}
