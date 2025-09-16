#!/bin/bash

# Get current session name and use it as default
current_name=$(tmux display-message -p '#S')

# Use gum input for a clean interface if available, otherwise fallback to read
if command -v gum >/dev/null 2>&1; then
    name=$(gum input --no-show-help --placeholder "New session name" --prompt "S > " --value "$current_name")
else
    # Fallback to tmux popup with read
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
    exit 0
fi

# Only rename if name is provided (gum input returns empty on ESC)
if [ -n "$name" ]; then
    tmux rename-session "$name"
fi