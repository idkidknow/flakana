os:
    nh os switch ../flakana-local

home:
    nh home switch ../flakana-local

gc:
    sudo nix-collect-garbage

tomori:
    deploy ../flakana-local#tomori

uika:
    deploy ../flakana-local#uika -- --impure
