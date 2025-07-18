{ inputs, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (inputs.nixpkgs-master.legacyPackages.x86_64-linux.hmcl.override {
          hmclJdk = jdk24;
          minecraftJdks = [
            jdk8
            jdk17
            jdk21
            jdk24
          ];
        })
        prismlauncher
      ];
    };
}
