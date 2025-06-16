{
  flake.modules.homeManager."idkana@mutsumi" =
    { ... }:
    {
      programs.git = {
        extraConfig = {
          credential.helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
        };
      };
    };
}
