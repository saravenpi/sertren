#!/bin/bash

# Always use tmux popup for reliable operation from key bindings
tmux popup -w 40% -h 20% -T " Confirm " -E "
    printf 'Kill this session? [y/N] '
    read -r answer
    case \"\$answer\" in
        [Yy]|[Yy][Ee][Ss])
            tmux kill-session
            ;;
    esac
"