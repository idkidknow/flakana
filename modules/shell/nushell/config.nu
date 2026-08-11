$env.config.buffer_editor = "emacsclient"
$env.config.show_banner = false
$env.config.use_kitty_protocol = true

$env.config.datetime_format.table = "%Y-%m-%d %H:%M:%S"

$env.config.filesize.unit = "binary"
$env.config.filesize.precision = 2

$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 1145141
$env.config.history.isolation = true

$env.PATH = $env.PATH
    | prepend "~/.local/bin"
    | uniq

$env.EDITOR = $env.config.buffer_editor

alias l = eza -Hgh --time-style=iso --icons always
alias ll = l -la

alias ec = emacsclient

use std/dirs
