#!/usr/bin/env bash
# PreToolUse(Bash) hook: remind the agent to run the leave-no-findings pass
# before a commit lands. Silent for every other command.
set -euo pipefail

payload="$(cat)"
command="$(printf '%s' "$payload" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null || true)"

case "$command" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac

cat <<'REMINDER'
[leave-no-findings] last pass before this commit:
  1. one accessor per piece of state — old one deleted, callers migrated?
  2. lifetime unit == display unit for any timer/cache/subscription?
  3. replaced a container — did you audit what it carried?
  4. new user-visible string — does it collide with an existing selector?
  5. any "safe because X" claim — is X true of THIS diff?
  6. changed an exported shape — grepped the test doubles for the old name?
  7. regression test — did you watch it fail with the fix reverted?
REMINDER
exit 0
