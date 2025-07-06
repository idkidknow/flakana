{
  flake.modules.nixos."hosts/sakiko" =
    { ... }:
    {
      fileSystems = {
        "/mnt/c" = {
          device = "/dev/disk/by-uuid/2C8851298850F336";
          options = [ "nofail" ];
        };
        "/mnt/d" = {
          device = "/dev/disk/by-uuid/6AA86BF5A86BBDE7";
          options = [ "nofail" ];
        };
        "/mnt/e" = {
          device = "/dev/disk/by-uuid/A8CC8232CC81FB38";
          options = [ "nofail" ];
        };
        "/mnt/f" = {
          device = "/dev/disk/by-uuid/E24E1E354E1E02C9";
          options = [ "nofail" ];
        };
      };
    };
}
