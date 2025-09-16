# Sertren - Smart Tmux Session Manager

**Sertren** is a tmux plugin that provides intelligent session management with fuzzy finding, zoxide integration, and enhanced safety features. It's designed to make switching between and managing tmux sessions effortless and intuitive.

## Features

### 🚀 Smart Session Management
- **Intelligent Session Switcher**: Navigate between existing sessions or create new ones with fuzzy finding
- **Zoxide Integration**: Automatically detects project paths using zoxide for new sessions
- **Egg Layout Support**: Auto-applies tmux layouts if `egg.yml` exists in the project directory
- **Session Renaming**: Quick session renaming with intuitive interface
- **Window Renaming**: Easy window renaming functionality

### 🛡️ Safety Features
- **Confirmation Dialogs**: Prevents accidental pane/session killing with confirmation prompts
- **Graceful Fallbacks**: Works with or without external dependencies like `gum`

## Installation

### Using TPM (Tmux Plugin Manager)

Add this line to your `~/.tmux.conf`:

```bash
set -g @plugin 'saravenpi/sertren'
```

Then press `prefix + I` to install the plugin.

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/saravenpi/sertren ~/.tmux/plugins/sertren
```

2. Add this line to your `~/.tmux.conf`:
```bash
run-shell ~/.tmux/plugins/sertren/sertren.tmux
```

3. Reload tmux configuration:
```bash
tmux source-file ~/.tmux.conf
```

## Dependencies

### Required
- **tmux** (obviously!)
- **fzf** - For the session switcher interface

### Optional (with graceful fallbacks)
- **zoxide** - For intelligent path detection when creating new sessions
- **gum** - For enhanced UI elements (confirmation dialogs, input fields)
- **egg** - For automatic tmux layout application

## Default Key Bindings

| Key | Action | Description |
|-----|--------|-------------|
| `prefix + o` | Session Switcher | Open the intelligent session switcher |
| `prefix + r` | Rename Window | Rename the current window |
| `prefix + R` | Rename Session | Rename the current session |
| `prefix + x` | Kill Pane (confirm) | Kill current pane with confirmation |
| `prefix + X` | Kill Session (confirm) | Kill current session with confirmation |

## Configuration

You can customize key bindings by setting these options in your `~/.tmux.conf`:

```bash
# Session management
set -g @sertren_session_switcher_key 'o'
set -g @sertren_session_rename_key 'R'
set -g @sertren_window_rename_key 'r'

# Safety features
set -g @sertren_kill_pane_key 'x'
set -g @sertren_kill_session_key 'X'
```

## Usage

### Session Switcher

Press `prefix + o` to open the session switcher. You can:

1. **Select existing sessions** - Use arrow keys or fuzzy search to find and switch to existing sessions
2. **Create new sessions** - Type a new name to create a session:
   - If the name matches a zoxide path, creates session in that directory
   - If the name is a valid directory path, creates session there
   - Otherwise creates session in home directory

### Renaming

- **Windows**: `prefix + r` - Opens input field with current window name
- **Sessions**: `prefix + R` - Opens input field with current session name

**Note**: Press `Ctrl+C` or `Escape` to cancel any rename operation.

### Safety Features

- **Kill Pane**: `prefix + x` - Asks for confirmation before killing current pane
- **Kill Session**: `prefix + X` - Asks for confirmation before killing current session

**Note**: Press `Ctrl+C` or `Escape` to cancel any confirmation dialog.

## Integration with Other Tools

### Zoxide
When creating new sessions, Sertren intelligently uses zoxide to find project directories:
1. Exact match lookup
2. Partial match search
3. Fallback to directory path or home

### Egg
If `egg.yml` exists in a project directory, Sertren automatically runs `egg --current` when creating a new session to apply your predefined tmux layout.

### Gum
When available, Sertren uses gum for enhanced UI elements. If not installed, it falls back to tmux popup-based interfaces.

## File Structure

```
sertren/
├── sertren.tmux              # Main plugin file
├── README.md                 # This file
├── LICENSE                   # MIT license
└── scripts/
    ├── session-switcher.sh   # Smart session switcher
    ├── rename-session.sh     # Session renaming
    ├── rename-window.sh      # Window renaming
    ├── confirm-kill-pane.sh  # Safe pane killing
    └── confirm-kill-session.sh # Safe session killing
```

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## License

MIT License - see LICENSE file for details.

## Author

Created by [saravenpi](https://github.com/saravenpi)

---

**Sertren** enhances your tmux workflow with intelligent session management, making it easy to navigate between projects and manage your development environment efficiently.