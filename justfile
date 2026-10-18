sync-priv:
    my flakana sync-priv ..

os: sync-priv
    nh os switch ../flakana-priv

home: sync-priv
    nh home switch ../flakana-priv -b bak

gc:
    nh clean all -k 2

tomori: sync-priv
    deploy ../flakana-priv\#tomori

uika: sync-priv
    deploy ../flakana-priv\#uika -- --impure

sm: sync-priv
    sudo system-manager switch --flake ../flakana-priv
