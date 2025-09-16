#!/bin/bash

# Always use tmux popup for reliable operation from key bindings
tmux popup -w 40% -h 20% -T " Confirm " -E "
    printf 'Kill this session? [y/N] '
    read -r answer
    # Check if user pressed Ctrl+C (escape equivalent)
    if [ \$? -ne 0 ]; then
        exit 0
    fi
    case \"\$answer\" in
        [Yy]|[Yy][Ee][Ss])
            tmux kill-session
            ;;
    esac
"