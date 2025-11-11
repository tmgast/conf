#!/bin/bash
# Smart auto-linting hook for Claude Code
# Runs appropriate linters based on project type and available tools

# Source color definitions
source ~/.claude/scripts/colors.sh

# Parse hook input JSON
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.toolName // ""')
FILE_PATH=$(echo "$INPUT" | jq -r '.toolArgs.file_path // ""')

# Only run on file edit tools
if [[ "$TOOL_NAME" != "Edit" && "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "MultiEdit" ]]; then
    exit 0
fi

# Get file extension
FILE_EXT=""
if [ -n "$FILE_PATH" ]; then
    FILE_EXT="${FILE_PATH##*.}"
fi

# Function to check if command exists
has_tool() {
    command -v "$1" >/dev/null 2>&1
}

# Function to run command silently and show result
run_linter() {
    local tool="$1"
    local cmd="$2"
    local file="$3"

    echo -e "${STATUS_INFO}Running ${tool}...${RESET}"

    if eval "$cmd" >/dev/null 2>&1; then
        echo -e "${STATUS_OK}${tool}: passed${RESET}"
        return 0
    else
        echo -e "${STATUS_WARN}${tool}: found issues (run manually for details)${RESET}"
        return 1
    fi
}

# Auto-lint based on file type and project configuration
auto_lint() {
    local linted=false

    # TypeScript/JavaScript files
    if [[ "$FILE_EXT" =~ ^(ts|tsx|js|jsx)$ ]]; then
        if [ -f "package.json" ]; then
            # ESLint
            if [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f "eslint.config.js" ] || grep -q '"eslint"' package.json 2>/dev/null; then
                if has_tool "npx"; then
                    run_linter "ESLint" "npx eslint \"$FILE_PATH\" --fix" "$FILE_PATH"
                    linted=true
                fi
            fi

            # Prettier
            if [ -f ".prettierrc" ] || [ -f ".prettierrc.json" ] || grep -q '"prettier"' package.json 2>/dev/null; then
                if has_tool "npx"; then
                    run_linter "Prettier" "npx prettier --write \"$FILE_PATH\"" "$FILE_PATH"
                    linted=true
                fi
            fi
        fi
    fi

    # Python files
    if [[ "$FILE_EXT" == "py" ]]; then
        # Ruff (modern Python linter/formatter)
        if has_tool "ruff"; then
            run_linter "Ruff format" "ruff format \"$FILE_PATH\"" "$FILE_PATH"
            run_linter "Ruff check" "ruff check \"$FILE_PATH\" --fix" "$FILE_PATH"
            linted=true
        else
            # Fallback to black + flake8
            if has_tool "black"; then
                run_linter "Black" "black \"$FILE_PATH\"" "$FILE_PATH"
                linted=true
            fi

            if has_tool "isort"; then
                run_linter "isort" "isort \"$FILE_PATH\"" "$FILE_PATH"
                linted=true
            fi
        fi
    fi

    # Go files
    if [[ "$FILE_EXT" == "go" ]]; then
        if has_tool "go"; then
            run_linter "gofmt" "go fmt \"$FILE_PATH\"" "$FILE_PATH"
            run_linter "goimports" "goimports -w \"$FILE_PATH\"" "$FILE_PATH" 2>/dev/null || true
            linted=true
        fi
    fi

    # Rust files
    if [[ "$FILE_EXT" == "rs" ]]; then
        if has_tool "rustfmt"; then
            run_linter "rustfmt" "rustfmt \"$FILE_PATH\"" "$FILE_PATH"
            linted=true
        fi
    fi

    # JSON files
    if [[ "$FILE_EXT" == "json" ]]; then
        if has_tool "jq"; then
            # Validate and pretty-print JSON
            if jq empty "$FILE_PATH" >/dev/null 2>&1; then
                run_linter "JSON format" "jq . \"$FILE_PATH\" > \"$FILE_PATH.tmp\" && mv \"$FILE_PATH.tmp\" \"$FILE_PATH\"" "$FILE_PATH"
                linted=true
            else
                echo -e "${STATUS_ERROR}JSON: invalid syntax${RESET}"
            fi
        fi
    fi

    # YAML files
    if [[ "$FILE_EXT" =~ ^(yml|yaml)$ ]]; then
        if has_tool "yamllint"; then
            run_linter "yamllint" "yamllint \"$FILE_PATH\"" "$FILE_PATH"
            linted=true
        fi
    fi

    # Shell scripts
    if [[ "$FILE_EXT" == "sh" ]] || [[ "$FILE_PATH" =~ \.bash$ ]]; then
        if has_tool "shellcheck"; then
            run_linter "shellcheck" "shellcheck \"$FILE_PATH\"" "$FILE_PATH"
            linted=true
        fi

        if has_tool "shfmt"; then
            run_linter "shfmt" "shfmt -w \"$FILE_PATH\"" "$FILE_PATH"
            linted=true
        fi
    fi

    if [ "$linted" = true ]; then
        echo -e "${STATUS_OK}Auto-linting completed${RESET}"
    else
        echo -e "${STATUS_INFO}No applicable linters found for ${FILE_EXT} files${RESET}"
    fi
}

# Run auto-linting
auto_lint