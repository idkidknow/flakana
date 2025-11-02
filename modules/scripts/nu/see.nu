#!/usr/bin/env nu

def main [path: path] {
  if ($path | path type) == "file" {
    bat $path
  } else {
    eza -Hgh --time-style=iso --icons always -la $path
  }
}
