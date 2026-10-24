sync-priv:
    my flakana sync-priv --path ..

os:
    my flakana os switch --path ..

home:
    my flakana home switch --path .. -b bak

gc:
    nh clean all -k 2

tomori: sync-priv
    deploy ../flakana-priv\#tomori

uika: sync-priv
    deploy ../flakana-priv\#uika -- --impure

sm: sync-priv
    sudo system-manager switch --flake ../flakana-priv
