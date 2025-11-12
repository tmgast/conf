#!/bin/bash
# Claude Code custom status line
# Shows: model | git status | dirty state | directory

# Source color definitions
source ~/.claude/scripts/colors.sh

# Read JSON input from Claude
INPUT=$(cat)

# Parse JSON using jq
MODEL_DISPLAY=$(echo "$INPUT" | jq -r '.model.display_name // "Claude"')
CWD=$(echo "$INPUT" | jq -r '.cwd // .workspace.current_dir // "~"')

# Get directory name with proper path handling
if [[ "$CWD" == "$HOME" ]]; then
    DIR_NAME="~"
elif [[ "$CWD" == "$HOME"/* ]]; then
    DIR_NAME="~${CWD#$HOME}"
else
    DIR_NAME="$CWD"
fi

# Use the display name directly (already clean)
MODEL_SHORT="$MODEL_DISPLAY"

# Git status check
GIT_STATUS=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")

    # Check if working directory is clean
    if git diff-index --quiet HEAD -- 2>/dev/null; then
        GIT_COLOR="$GIT_CLEAN"
        GIT_SYMBOL="✓"
    else
        GIT_COLOR="$GIT_DIRTY"
        GIT_SYMBOL="●"
    fi

    # Check for ahead/behind
    AHEAD_BEHIND=""
    if git rev-parse --abbrev-ref --symbolic-full-name @{u} > /dev/null 2>&1; then
        AHEAD=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
        BEHIND=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")

        if [ "$AHEAD" -gt 0 ] && [ "$BEHIND" -gt 0 ]; then
            AHEAD_BEHIND="${GIT_DIVERGED}↕${AHEAD}/${BEHIND}"
        elif [ "$AHEAD" -gt 0 ]; then
            AHEAD_BEHIND="${GIT_BEHIND}↓${AHEAD}"
        elif [ "$BEHIND" -gt 0 ]; then
            AHEAD_BEHIND="${GIT_AHEAD}↑${BEHIND}"
        fi
    fi

    GIT_STATUS="${GIT_COLOR}${BRANCH} ${GIT_SYMBOL}${AHEAD_BEHIND}"
fi

# Check project health (lint/type errors) - simplified for speed
HEALTH_STATUS=""

# Function to check if command exists
has_tool() {
    command -v "$1" >/dev/null 2>&1
}

# Quick project health check (no actual linting, just file presence)
check_project_health() {
    local checks=""

    # Check for common project files to determine what checks would be relevant
    if [ -f "package.json" ]; then
        if [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f "eslint.config.js" ]; then
            checks="${checks}${LINT_CLEAN}L"
        fi
        if [ -f "tsconfig.json" ]; then
            checks="${checks}${TYPE_CLEAN}T"
        fi
    fi

    if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
        if has_tool "ruff" || has_tool "flake8"; then
            checks="${checks}${LINT_CLEAN}P"
        fi
    fi

    if [ -f "go.mod" ] && has_tool "go"; then
        checks="${checks}${LINT_CLEAN}G"
    fi

    if [ -f "Cargo.toml" ] && has_tool "cargo"; then
        checks="${checks}${LINT_CLEAN}R"
    fi

    if [ -n "$checks" ]; then
        HEALTH_STATUS="${STATUS_OK}[${checks}${STATUS_OK}]"
    fi
}

# Check project health
check_project_health

# Define separators for cleaner look
SEP="${BOLD_BLACK} | ${RESET}"
SPACE=" "

# Build status line with proper spacing and separators
STATUS_LINE=""

# Model name (always first)
STATUS_LINE="${MODEL_NAME}${MODEL_SHORT}${RESET}"

# Git status (if in git repo)
if [ -n "$GIT_STATUS" ]; then
    STATUS_LINE="${STATUS_LINE}${SEP}${GIT_STATUS}${RESET}"
fi

# Project health (if applicable)
if [ -n "$HEALTH_STATUS" ]; then
    STATUS_LINE="${STATUS_LINE}${SPACE}${HEALTH_STATUS}${RESET}"
fi

# Directory (always show)
STATUS_LINE="${STATUS_LINE}${SEP}${STATUS_INFO}${DIR_NAME}${RESET}"

echo -e "$STATUS_LINE"