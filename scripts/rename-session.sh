#!/bin/bash

# Get current session name and use it as default
current_name=$(tmux display-message -p '#S')

# Always use tmux popup for reliable operation from key bindings
tmux popup -w 50% -h 20% -T " Rename Session " -E "
    printf 'Session name [$current_name]: '
    read -r name
    if [ -z \"\$name\" ]; then
        name=\"$current_name\"
    fi
    if [ -n \"\$name\" ]; then
        tmux rename-session \"\$name\"
    fi
"