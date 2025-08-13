{ inputs, ... }:
{
  flake.modules.homeManager."idkana@sakiko" =
    { ... }:
    let
      inherit (inputs.steamux.packages.x86_64-linux) steamux;
    in
    {
      home.packages = [
        (inputs.nix-gaming.packages.x86_64-linux.osu-stable.override {
          preCommands = ''
            unset WINEARCH
            if [ -e "$WINEPREFIX/steamux.sock" ]; then
                if [ -z "$1" ]; then
                    ${steamux}/bin/steamuxctl --socket-path $WINEPREFIX/steamux.sock run -p -- "$OSU"
                else
                    ARG1_COMPAT_PATH="$(${steamux}/bin/steamuxctl --socket-path $WINEPREFIX/steamux.sock run -- "$PROTONPATH/proton" getcompatpath "$(realpath "$1")")"
                    shift
                    ${steamux}/bin/steamuxctl --socket-path $WINEPREFIX/steamux.sock run -p -- "$OSU" "$ARG1_COMPAT_PATH" "$@"
                fi
            else
                ${steamux}/bin/steamux umu --socket-path $WINEPREFIX/steamux.sock -- "$OSU" "$@"
            fi
            exit
          '';
        })
      ];
    };
}
