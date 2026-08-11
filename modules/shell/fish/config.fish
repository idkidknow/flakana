set -g fish_greeting ''
set -gx EDITOR emacsclient
fish_add_path ~/.local/bin
alias l="eza -Hgh --time-style=iso --icons always"
alias ll="l -la"
