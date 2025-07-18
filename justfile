update-stale:
    jj st --no-pager
    jj workspace update-stale --repository ../flakana-priv

os: update-stale
    nh os switch ../flakana-priv

home: update-stale
    nh home switch ../flakana-priv -b bak

gc:
    nh clean all -k 2

tomori: update-stale
    deploy ../flakana-priv\#tomori

uika: update-stale
    deploy ../flakana-priv\#uika -- --impure
