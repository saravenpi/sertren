#!/bin/bash

# Get current window name and use it as default
current_name=$(tmux display-message -p '#W')

# Always use tmux popup for reliable operation from key bindings
tmux popup -w 50% -h 20% -T " Rename Window " -E "
    printf 'Window name [$current_name]: '
    read -r name
    # Check if user pressed Ctrl+C (escape equivalent)
    if [ \$? -ne 0 ]; then
        exit 0
    fi
    if [ -z \"\$name\" ]; then
        name=\"$current_name\"
    fi
    if [ -n \"\$name\" ]; then
        tmux rename-window \"\$name\"
    fi
"