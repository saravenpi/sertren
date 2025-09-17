#!/bin/bash

current_name=$(tmux display-message -p '#W')

if command -v gum >/dev/null 2>&1; then
    tmux popup -w 40 -h 3 -T " Rename Window " -E "
        name=\$(gum input --no-show-help --placeholder 'New window name' --prompt 'Window > ' --value \"$current_name\")
        if [ \$? -eq 0 ] && [ -n \"\$name\" ]; then
            tmux rename-window \"\$name\"
        fi
    "
else
    tmux command-prompt -I "$current_name" -p "Rename window:" "rename-window '%%'"
fi