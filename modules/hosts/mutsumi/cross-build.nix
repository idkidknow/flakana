{
  flake.modules.nixos."hosts/mutsumi" = {
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    wsl.interop.register = true; # Having any binfmt registrations without re-registering WSLInterop (wsl.interop.register) will break running .exe files from WSL2
  };
}
