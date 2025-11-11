#!/bin/bash
# Color definitions for Claude Code customizations
# Usage: source ~/.claude/scripts/colors.sh

# Reset
RESET='\033[0m'

# Regular colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bold colors
BOLD_BLACK='\033[1;30m'
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_PURPLE='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

# Background colors
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

# Semantic colors (using Kanagawa palette)
STATUS_OK="${GREEN}"
STATUS_WARN="${YELLOW}"
STATUS_ERROR="${RED}"
STATUS_INFO="${BLUE}"
STATUS_ACCENT="${PURPLE}"

# Git status colors
GIT_CLEAN="${GREEN}"
GIT_DIRTY="${YELLOW}"
GIT_AHEAD="${BLUE}"
GIT_BEHIND="${RED}"
GIT_DIVERGED="${PURPLE}"

# Project status colors
LINT_CLEAN="${GREEN}"
LINT_DIRTY="${RED}"
TYPE_CLEAN="${CYAN}"
TYPE_DIRTY="${YELLOW}"

# Model status colors
MODEL_NAME="${BOLD_BLUE}"
MODEL_VERSION="${CYAN}"

# Function to colorize text
colorize() {
    local color="$1"
    local text="$2"
    echo -e "${color}${text}${RESET}"
}