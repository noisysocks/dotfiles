#!/bin/bash
# Auto-format the edited file with the project's oxfmt or prettier, if available.
# Only touches files inside the project directory, so temporary scripts Claude
# writes to /tmp and the like are left alone.

FILE=$(jq -r '.tool_input.file_path // empty')
[ -n "$FILE" ] || exit 0

PROJECT_ROOT=$(cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null && pwd) || exit 0

# Skip anything outside the project directory. (Write/Edit always pass an
# absolute file_path, so a plain prefix match is enough.)
case "$FILE" in
  "$PROJECT_ROOT"/*) ;;
  *) exit 0 ;;
esac

# Defer to a project-defined Edit/Write PostToolUse hook, if any.
for settings in "$PROJECT_ROOT/.claude/settings.json" "$PROJECT_ROOT/.claude/settings.local.json"; do
  [ -f "$settings" ] || continue
  jq -e '(.hooks.PostToolUse // []) | map(.matcher // "") | any(test("Edit|Write"))' \
    "$settings" >/dev/null 2>&1 && exit 0
done

# Prefer project-local oxfmt, fall back to prettier.
for fmt in oxfmt prettier; do
  bin="$PROJECT_ROOT/node_modules/.bin/$fmt"
  if [ -x "$bin" ]; then
    "$bin" --write "$FILE" >/dev/null 2>&1
    exit 0
  fi
done
