#!/bin/bash

current_name=$(tmux display-message -p '#S')

if command -v gum >/dev/null 2>&1; then
    tmux popup -w 40 -h 3 -T " Rename Session " -E "
        name=\$(gum input --no-show-help --placeholder 'New session name' --prompt 'Session > ' --value \"$current_name\")
        if [ \$? -eq 0 ] && [ -n \"\$name\" ]; then
            tmux rename-session \"\$name\"
        fi
    "
else
    tmux command-prompt -I "$current_name" -p "Rename session:" "rename-session '%%'"
fi