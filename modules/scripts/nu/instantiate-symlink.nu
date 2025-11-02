#!/usr/bin/env nu

def main [file: path] {
  let tmp_file = mktemp -t instantiate-symlink.XXXXX
  cp $file $tmp_file
  rm $file
  mv $tmp_file $file
  chmod u+w $file
}
