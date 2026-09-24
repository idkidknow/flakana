#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell jujutsu just
print "path:"
let path = (input)
mkdir $path
cd $path
mkdir flakana
mkdir flakana-priv/private-modules
cd flakana
jj git init
jj git remote add origin https://github.com/idkidknow/flakana.git
jj git fetch
jj bookmark track main@origin
jj new main
just sync-priv
cd ../flakana-priv/private-modules
jj git init
jj git remote add origin https://github.com/idkidknow/flakana-priv.git
jj git fetch
jj bookmark track main@origin
jj new main
