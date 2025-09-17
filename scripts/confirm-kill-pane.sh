#!/bin/bash

if command -v gum >/dev/null 2>&1; then
    tmux popup -w 30 -h 5 -T " Confirm " -E "bash -c '
        if gum confirm --no-show-help \"Kill this pane?\"; then
            tmux kill-pane
        fi
    '"
else
    tmux confirm-before -p "Kill this pane? (y/n)" kill-pane
fi