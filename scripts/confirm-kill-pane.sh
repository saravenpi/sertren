#!/bin/bash

# Use gum if available, otherwise fallback to basic tmux popup
if command -v gum >/dev/null 2>&1; then
    # Run gum inside tmux popup for proper terminal context
    tmux popup -w 40% -h 20% -T " Confirm " -E "
        if gum confirm --no-show-help 'Kill this pane?'; then
            tmux kill-pane
        fi
    "
else
    # Fallback to basic tmux popup
    tmux popup -w 40% -h 20% -T " Confirm " -E "
        printf 'Kill this pane? [y/N] '
        read -r answer
        # Check if user pressed Ctrl+C (escape equivalent)
        if [ \$? -ne 0 ]; then
            exit 0
        fi
        case \"\$answer\" in
            [Yy]|[Yy][Ee][Ss])
                tmux kill-pane
                ;;
        esac
    "
fi