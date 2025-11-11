#!/bin/bash
# Claude Code Configuration Setup Script
#
# This script symlinks Claude configuration files from your conf directory
# to ~/.claude/ allowing you to version control your Claude settings.
#
# Usage: ./setup.sh [conf_path]
#   conf_path: Optional path to conf directory (defaults to script directory)

set -e  # Exit on error

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Helper functions
info() { echo -e "${BLUE}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[OK]${RESET} $1"; }
warn() { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error() { echo -e "${RED}[ERROR]${RESET} $1"; exit 1; }

# Determine source directory (conf/claude)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_CLAUDE_DIR="${1:-$SCRIPT_DIR}"

# Validate source directory
if [ ! -d "$CONF_CLAUDE_DIR" ]; then
    error "Configuration directory not found: $CONF_CLAUDE_DIR"
fi

# Target directory
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backup-$(date +%Y%m%d-%H%M%S)"

info "Setting up Claude Code configuration..."
info "Source: $CONF_CLAUDE_DIR"
info "Target: $CLAUDE_DIR"

# Create .claude directory if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Function to safely create symlink
create_symlink() {
    local src="$1"
    local dest="$2"
    local rel_path="$3"  # For display purposes

    # If destination is already a symlink pointing to source, skip
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        success "Already linked: $rel_path"
        return 0
    fi

    # If destination exists and is not a symlink, back it up
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$rel_path")"
        warn "Backing up existing file: $rel_path"
        mv "$dest" "$BACKUP_DIR/$rel_path"
    fi

    # Remove existing symlink if it points elsewhere
    if [ -L "$dest" ]; then
        rm "$dest"
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # Create symlink
    ln -s "$src" "$dest"
    success "Linked: $rel_path"
}

# Files to symlink (relative paths)
declare -a FILES=(
    "CLAUDE.md"
    "vue-patterns.md"
    "settings.json"
    "settings.local.json"
    "scripts/auto-lint.sh"
    "scripts/colors.sh"
    "scripts/statusline.sh"
    "plugins/config.json"
)

# Create symlinks
info "Creating symlinks..."
for file in "${FILES[@]}"; do
    src="$CONF_CLAUDE_DIR/$file"
    dest="$CLAUDE_DIR/$file"

    if [ ! -e "$src" ]; then
        warn "Source file not found, skipping: $file"
        continue
    fi

    create_symlink "$src" "$dest" "$file"
done

# Make scripts executable
info "Setting script permissions..."
for script in "$CONF_CLAUDE_DIR/scripts"/*.sh; do
    if [ -f "$script" ]; then
        chmod +x "$script"
        success "Made executable: $(basename "$script")"
    fi
done

# Summary
echo ""
if [ -d "$BACKUP_DIR" ]; then
    warn "Original files backed up to: $BACKUP_DIR"
fi
success "Claude Code configuration setup complete!"
info "Your configuration is now synced from: $CONF_CLAUDE_DIR"
info "You can safely commit and push the claude/ directory to version control."
