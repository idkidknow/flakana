os:
    nh os switch .

home:
    nh home switch .

gc:
    sudo nix-collect-garbage

tomori:
    deploy .#tomori

uika:
    deploy .#uika -- --impure
