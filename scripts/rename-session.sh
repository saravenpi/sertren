#!/bin/bash

# Get current session name and use it as default
current_name=$(tmux display-message -p '#S')

# Use gum if available, otherwise fallback to basic tmux popup
if command -v gum >/dev/null 2>&1; then
    # Run gum inside tmux popup for proper terminal context
    tmux popup -w 50% -h 20% -T " Rename Session " -E "
        name=\$(gum input --placeholder 'New session name' --prompt 'Session > ' --value '$current_name')
        if [ \$? -eq 0 ] && [ -n \"\$name\" ]; then
            tmux rename-session \"\$name\"
        fi
    "
else
    # Fallback to basic tmux popup
    tmux popup -w 50% -h 20% -T " Rename Session " -E "
        printf 'Session name [$current_name]: '
        read -r name
        # Check if user pressed Ctrl+C (escape equivalent)
        if [ \$? -ne 0 ]; then
            exit 0
        fi
        if [ -z \"\$name\" ]; then
            name=\"$current_name\"
        fi
        if [ -n \"\$name\" ]; then
            tmux rename-session \"\$name\"
        fi
    "
fi