#!/bin/bash

# Get current window name and use it as default
current_name=$(tmux display-message -p '#W')

# Use gum input for a clean interface if available, otherwise fallback to read
if command -v gum >/dev/null 2>&1; then
    name=$(gum input --no-show-help --placeholder "New window name" --prompt "W > " --value "$current_name")
else
    # Fallback to tmux popup with read
    tmux popup -w 50% -h 20% -T " Rename Window " -E "
        printf 'Window name [$current_name]: '
        read -r name
        if [ -z \"\$name\" ]; then
            name=\"$current_name\"
        fi
        if [ -n \"\$name\" ]; then
            tmux rename-window \"\$name\"
        fi
    "
    exit 0
fi

# Only rename if name is provided (gum input returns empty on ESC)
if [ -n "$name" ]; then
    tmux rename-window "$name"
fi