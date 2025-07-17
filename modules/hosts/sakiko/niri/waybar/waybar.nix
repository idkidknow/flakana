{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      programs.waybar = {
        enable = true;
      };

      xdg.configFile = {
        "waybar/config.jsonc".source = ./config.jsonc;
        "waybar/mocha.css".source = ./mocha.css;
        "waybar/style.css".source = ./style.css;
      };
    };
}
