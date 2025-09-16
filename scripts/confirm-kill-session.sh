#!/bin/bash

# Use gum confirm for confirmation if available, otherwise fallback to tmux popup
if command -v gum >/dev/null 2>&1; then
    if gum confirm --no-show-help "Kill this session?"; then
        tmux kill-session
    fi
else
    # Fallback to tmux popup with confirmation
    tmux popup -w 40% -h 20% -T " Confirm " -E "
        printf 'Kill this session? [y/N] '
        read -r answer
        case \"\$answer\" in
            [Yy]|[Yy][Ee][Ss])
                tmux kill-session
                ;;
        esac
    "
fi