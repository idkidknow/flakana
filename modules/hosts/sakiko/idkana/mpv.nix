{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    {
      programs.mpv = {
        enable = true;
        config = {
          border = false;
          keep-open = true;
          save-position-on-quit = true;
          hwdec = "auto";
          vo = "gpu-next";
          gpu-api = "vulkan";
          audio-file-auto = "fuzzy";
          sub-auto = "fuzzy";
        };
      };
    };
}
