os:
    nh os switch ../flakana-priv

home:
    nh home switch ../flakana-priv

gc:
    nh clean all -k 2

tomori:
    deploy ../flakana-priv\#tomori

uika:
    deploy ../flakana-priv\#uika -- --impure
