{ inputs, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      home.packages = [
        (inputs.quickshell.packages.x86_64-linux.default.withModules (
          with pkgs.kdePackages;
          [
            qtmultimedia
          ]
        ))
      ];
    };
}
