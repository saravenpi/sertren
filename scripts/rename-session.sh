#!/bin/bash

# Get current session name and use it as default
current_name=$(tmux display-message -p '#S')

# Use gum if available, otherwise fallback to tmux popup
if command -v gum >/dev/null 2>&1 && [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ] || [ -n "$TERM_PROGRAM" ]; then
    # Use gum for better UX when available and in a proper terminal context
    name=$(gum input --placeholder "New session name" --prompt "Session > " --value "$current_name" 2>/dev/null)
    exit_code=$?

    # Check if gum succeeded and user didn't cancel
    if [ $exit_code -eq 0 ] && [ -n "$name" ]; then
        tmux rename-session "$name"
    fi
else
    # Fallback to tmux popup for reliable operation from key bindings
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