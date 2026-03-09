#!/bin/bash

get_sessions() {
    tmux list-sessions -F "#{session_last_attached} #{session_name}" 2>/dev/null | \
        sort -rn | cut -d' ' -f2-
}

current_session=$(tmux display-message -p '#S' 2>/dev/null)

selected=$(
    {
        echo "$current_session"
        get_sessions | grep -v "^$current_session$"
        echo ""
        echo "[new session]"
    } | fzf --prompt="Session > " --height=40% --reverse --no-preview
)

[ -z "$selected" ] && exit 0

if [ "$selected" = "$current_session" ]; then
    exit 0
fi

if [ "$selected" = "[new session]" ]; then
    tmux command-prompt -p "New session name:" "run-shell \"$0 create '%%'\""
    exit 0
fi

if tmux has-session -t "$selected" 2>/dev/null; then
    tmux switch-client -t "$selected"
    exit 0
fi

if [ "$1" = "create" ]; then
    session_name="$2"
    [ -z "$session_name" ] && exit 0

    project_path=$(zoxide query "$session_name" 2>/dev/null)

    if [ -z "$project_path" ]; then
        project_path=$(zoxide query --list 2>/dev/null | grep -i "$session_name" | head -1)
    fi

    if [ -z "$project_path" ]; then
        if [ -d "$session_name" ]; then
            project_path=$(cd "$session_name" && pwd)
            zoxide add "$project_path" 2>/dev/null
        else
            project_path="$HOME"
        fi
    fi

    [ ! -d "$project_path" ] && project_path="$HOME"

    tmux new-session -d -s "$session_name" -c "$project_path"
    tmux switch-client -t "$session_name"

    if [ -f "$project_path/egg.yml" ]; then
        tmux send-keys -t "$session_name" 'egg --current' Enter
    fi
fi
