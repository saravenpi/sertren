#!/bin/bash

# Use gum if available, otherwise fallback to tmux popup
if command -v gum >/dev/null 2>&1 && [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ] || [ -n "$TERM_PROGRAM" ]; then
    # Use gum for better UX when available and in a proper terminal context
    if gum confirm "Kill this pane?" 2>/dev/null; then
        tmux kill-pane
    fi
else
    # Fallback to tmux popup for reliable operation from key bindings
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