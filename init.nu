#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell jujutsu
print "path:"
let path = (input)
mkdir $path
cd $path
mkdir flakana
cd flakana
jj git init
jj git remote add public https://github.com/idkidknow/flakana.git
jj git remote add priv https://github.com/idkidknow/flakana-priv.git
jj git fetch --remote public
jj git fetch --remote priv --branch priv
jj bookmark track main@public priv@priv
jj new main
jj workspace add ../flakana-priv
jj edit priv --repository ../flakana-priv
