{ inputs, config, ... }:
{
  flake.modules.homeManager."idkana@emilia" =
    { pkgs, ... }:
    {
      imports = [ config.flake.modules.homeManager.common ];

      home.stateVersion = "26.11";
      home.username = "idkana";
      home.homeDirectory = "/home/idkana";

      home.packages = with pkgs; [
        emacs
        fastfetch
        python3
        nodejs
        inputs.llm-agents.packages.aarch64-linux.pi
      ];
    };
}
