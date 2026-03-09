#!/bin/bash

# Sertren - tmux session switcher with zoxide integration
# Shows only active sessions and allows creating new ones with smart path detection

tmux_session_switcher() {
    local current_session=""
    local sessions=()
    local all_options=()

    # Get current tmux session if we're in one
    if [ -n "$TMUX" ]; then
        current_session=$(tmux display-message -p '#S')
    fi

    # Get existing tmux sessions ordered by last activity (most recent first)
    while IFS= read -r line; do
        local session=$(echo "$line" | cut -d: -f1)
        if [ "$session" != "$current_session" ]; then
            sessions+=("$session")
            all_options+=("$session")
        fi
    done < <(tmux list-sessions -F "#{session_last_attached} #{session_name}" 2>/dev/null | sort -rn | cut -d' ' -f2-)

    # Add current session at the top if we have one
    if [ -n "$current_session" ]; then
        all_options=("$current_session (current)" "${all_options[@]}")
    fi

    # Build session list display (with numbers for easy selection)
    local display_message="Sessions:\n"
    local i=1
    for session in "${all_options[@]}"; do
        display_message+="$i) $session\n"
        ((i++))
    done
    display_message+="\nSelect session number or type new session name:"

    # Show available sessions in a popup
    tmux display-popup -w 60% -h 60% -T " Sertren " -E "
        echo '${display_message}'
        read -p 'Session > ' response
        echo \"\$response\" > /tmp/sertren-session-$$
    "

    # Read the response
    local response=$(cat /tmp/sertren-session-$$ 2>/dev/null)
    rm -f /tmp/sertren-session-$$

    # Exit if no selection
    if [ -z "$response" ]; then
        exit 0
    fi

    # Check if response is a number (selecting from list)
    if [[ "$response" =~ ^[0-9]+$ ]]; then
        local index=$((response - 1))
        if [ $index -ge 0 ] && [ $index -lt ${#all_options[@]} ]; then
            local selection="${all_options[$index]}"

            # Handle current session selection
            if [[ "$selection" == *"(current)" ]]; then
                exit 0
            fi

            # Clean the selection and switch
            session_name=$(echo "$selection" | sed 's/ (current)$//' | xargs)
            if tmux has-session -t "$session_name" 2>/dev/null; then
                tmux switch-client -t "$session_name"
                exit 0
            fi
        fi
        exit 0
    fi

    # Treat response as new session name
    session_name="$response"

    # Check if it's an existing session first
    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux switch-client -t "$session_name"
        exit 0
    fi

    # Try to get path from zoxide
    project_path=$(zoxide query "$session_name" 2>/dev/null)

    # If no exact match, try listing all and grep for partial matches
    if [ -z "$project_path" ]; then
        project_path=$(zoxide query --list | grep -i "$session_name" | head -1)
    fi

    # If still no match, check if it's a valid directory path or use current directory
    if [ -z "$project_path" ]; then
        if [ -d "$session_name" ]; then
            project_path=$(cd "$session_name" && pwd)
            zoxide add "$project_path" 2>/dev/null
        else
            project_path="$HOME"
        fi
    fi

    # Ensure we have a valid directory
    if [ ! -d "$project_path" ]; then
        project_path="$HOME"
    fi

    # Create the new session
    tmux new-session -d -s "$session_name" -c "$project_path"
    tmux switch-client -t "$session_name"

    # Apply the tmux layout with egg --current if egg.yml exists
    if [ -f "$project_path/egg.yml" ]; then
        tmux send-keys -t "$session_name" 'egg --current' Enter
    fi
}

# Run the function
tmux_session_switcher
