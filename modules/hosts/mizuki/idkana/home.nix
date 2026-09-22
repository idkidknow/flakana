{ inputs, config, ... }:
{
  flake.modules.homeManager."idkana@mizuki" =
    { pkgs, ... }:
    {
      imports = [
        config.flake.modules.homeManager.common
        config.flake.modules.homeManager.common-desktop
      ];

      home.stateVersion = "26.11";
      home.username = "idkana";
      home.homeDirectory = "/home/idkana";

      home.packages = with pkgs; [
        fastfetch
        python3
        nodejs
        pnpm
        glow
        inputs.llm-agents.packages.x86_64-linux.codex
        inputs.llm-agents.packages.x86_64-linux.pi
        (inputs.llm-agents.packages.x86_64-linux.chatgpt.overrideAttrs (prev: {
          postFixup = (prev.postFixup or "") + ''
            wrapProgram "$out/bin/chatgpt" \
              --prefix PATH : ${lib.makeBinPath [ bubblewrap ]}
          '';
        }))
      ];

      programs.emacs.enable = true;
      services.emacs.enable = true;

      programs.alacritty.enable = true;

      systemd.user.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };
}
