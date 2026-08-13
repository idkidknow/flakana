function rl-backward-word --description 'Move like GNU Readline M-b'
    set -l line "$(commandline)"
    set -l pos (commandline --cursor)

    while test $pos -gt 0
        set -l char (string sub --start $pos --length 1 -- "$line")
        if string match -q -r '^[[:alnum:]]$' -- "$char"
            break
        end
        set pos (math $pos - 1)
    end

    while test $pos -gt 0
        set -l char (string sub --start $pos --length 1 -- "$line")
        if not string match -q -r '^[[:alnum:]]$' -- "$char"
            break
        end
        set pos (math $pos - 1)
    end

    commandline --cursor $pos
end
