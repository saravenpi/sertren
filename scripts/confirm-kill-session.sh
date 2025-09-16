#!/bin/bash

if command -v gum >/dev/null 2>&1; then
    tmux popup -w 30 -h 5 -T " Confirm " -E "
        if gum confirm --no-show-help 'Kill this session?'; then
            tmux kill-session
        fi
    "
else
    tmux confirm-before -p "Kill this session? (y/n)" kill-session
fi