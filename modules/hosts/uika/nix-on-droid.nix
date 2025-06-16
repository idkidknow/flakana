{ inputs, config, ... }:
{
  hosts.uika.system = "aarch64-linux";

  flake.modules.nixOnDroid."hosts/uika" =
    { pkgs, ... }:
    {
      system.stateVersion = "24.05";
      environment.etcBackupExtension = ".bak";
      nix.extraOptions = ''
        experimental-features = nix-command flakes pipe-operators
      '';
      time.timeZone = "Asia/Shanghai";
      build.extraProotOptions = [
        "-k"
        "\"\\\\Linux\\\\uika\\\\4.19.157-perf-gf8cf95f4dc15\\\\#1 SMP PREEMPT Tue May 7 07:59:22 UTC 2024\\\\aarch64\\\\localdomain\\\\-1\\\\\""
      ];

      user.userName = "idkana";
      user.group = "idkana";
      user.uid = 10384;
      user.gid = 10384;

      nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      nix.substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.garnix.io"
        "https://nix-on-droid.cachix.org"
      ];
      nix.trustedPublicKeys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU="
      ];

      environment.packages = with pkgs; [
        micro
        openssh
        uutils-coreutils-noprefix
      ];

      home-manager.config = config.flake.modules.homeManager."idkana@uika";

      android-integration.termux-open.enable = true;
      android-integration.xdg-open.enable = true;
      android-integration.termux-open-url.enable = true;
      android-integration.termux-reload-settings.enable = true;
      android-integration.termux-setup-storage.enable = true;

      terminal.font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNLNerdFont-Regular.ttf";
    };

  flake.modules.homeManager."idkana@uika" =
    { ... }:
    {
      imports = [ config.flake.modules.homeManager.common ];

      home.stateVersion = "25.05";
    };
}
