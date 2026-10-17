{ self, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.scala-cli
        self.packages.x86_64-linux.mill-unwrapped
      ];
      programs.java = {
        enable = true;
        package = pkgs.jdk25;
      };
    };
}
