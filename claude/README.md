# Claude Code Configuration

This directory contains version-controlled Claude Code configuration files.

## Structure

```
claude/
├── CLAUDE.md              # Main coding guidelines and principles
├── vue-patterns.md        # Vue 3 & Nuxt 3 development patterns
├── settings.json          # Claude hooks configuration
├── settings.local.json    # Claude permissions configuration
├── scripts/
│   ├── auto-lint.sh       # Auto-linting hook
│   ├── colors.sh          # Color definitions
│   └── statusline.sh      # Custom status line
├── plugins/
│   └── config.json        # Plugin configuration
├── setup.sh               # Setup script
└── README.md              # This file
```

## Setup

Run the setup script to create symlinks from `~/.claude/` to this directory:

```bash
./setup.sh
```

The script will:
- Back up any existing files in `~/.claude/` (stored in `~/.claude/backup-TIMESTAMP/`)
- Create symlinks from `~/.claude/` to `conf/claude/`
- Make scripts executable
- Be safe to run multiple times (idempotent)

## Usage

After setup, any changes to files in this directory will automatically be reflected in Claude Code since `~/.claude/` symlinks to here.

To sync changes across machines:
1. Commit and push changes to this directory
2. Pull changes on other machine
3. Run `./setup.sh` to create symlinks

## What's NOT Synced

The following directories in `~/.claude/` are intentionally excluded (local state):
- `history.jsonl` - Chat history
- `debug/` - Debug logs
- `file-history/` - File edit history
- `projects/` - Project-specific state
- `session-env/` - Session environment
- `shell-snapshots/` - Shell history
- `statsig/` - Telemetry data
- `todos/` - Todo state

## Customization

### Scripts

All scripts use `~/.claude/scripts/` paths, which will resolve correctly via symlinks.

### Hooks

The `settings.json` configures post-tool-use hooks:
- Auto-linting runs after Edit/Write operations
- Status line shows model, git status, and project health

### Permissions

The `settings.local.json` defines auto-approved commands to reduce prompts.
