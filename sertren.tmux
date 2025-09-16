#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Default key bindings
default_session_switcher_key="o"
default_session_rename_key="r"
default_window_rename_key="R"
default_kill_pane_key="x"
default_kill_session_key="X"

# Get key bindings from tmux options or use defaults
session_switcher_key=$(tmux show-option -gqv @sertren_session_switcher_key)
session_rename_key=$(tmux show-option -gqv @sertren_session_rename_key)
window_rename_key=$(tmux show-option -gqv @sertren_window_rename_key)
kill_pane_key=$(tmux show-option -gqv @sertren_kill_pane_key)
kill_session_key=$(tmux show-option -gqv @sertren_kill_session_key)

session_switcher_key=${session_switcher_key:-$default_session_switcher_key}
session_rename_key=${session_rename_key:-$default_session_rename_key}
window_rename_key=${window_rename_key:-$default_window_rename_key}
kill_pane_key=${kill_pane_key:-$default_kill_pane_key}
kill_session_key=${kill_session_key:-$default_kill_session_key}

# Set up key bindings
tmux bind-key $session_switcher_key run-shell "$CURRENT_DIR/scripts/session-switcher.sh"
tmux bind-key $session_rename_key run-shell "$CURRENT_DIR/scripts/rename-session.sh"
tmux bind-key $window_rename_key run-shell "$CURRENT_DIR/scripts/rename-window.sh"
tmux bind-key $kill_pane_key run-shell "$CURRENT_DIR/scripts/confirm-kill-pane.sh"
tmux bind-key $kill_session_key run-shell "$CURRENT_DIR/scripts/confirm-kill-session.sh"