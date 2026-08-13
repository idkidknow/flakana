function rl-forward-word --description 'Move like GNU Readline M-f'
    set -l line "$(commandline)"
    set -l pos (commandline --cursor)
    set -l length (string length -- "$line")

    while test $pos -lt $length
        set -l char (string sub --start (math $pos + 1) --length 1 -- "$line")
        if string match -q -r '^[[:alnum:]]$' -- "$char"
            break
        end
        set pos (math $pos + 1)
    end

    while test $pos -lt $length
        set -l char (string sub --start (math $pos + 1) --length 1 -- "$line")
        if not string match -q -r '^[[:alnum:]]$' -- "$char"
            break
        end
        set pos (math $pos + 1)
    end

    commandline --cursor $pos
end
