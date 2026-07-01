#!/bin/bash
# Auto-format the edited file with the project's oxfmt or prettier, if available

FILE=$(jq -r '.tool_input.file_path // empty')

if [ -z "$FILE" ]; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

# 1. Defer to a project-defined Edit/Write PostToolUse hook, if any.
for settings in "$PROJECT_DIR/.claude/settings.json" "$PROJECT_DIR/.claude/settings.local.json"; do
  [ -f "$settings" ] || continue
  if jq -e '
      (.hooks.PostToolUse // [])
      | map(.matcher // "")
      | any(test("Edit|Write"))
    ' "$settings" >/dev/null 2>&1; then
    exit 0
  fi
done

# 2. Prefer project-local oxfmt.
if [ -x "$PROJECT_DIR/node_modules/.bin/oxfmt" ]; then
  "$PROJECT_DIR/node_modules/.bin/oxfmt" --write "$FILE" >/dev/null 2>&1
  exit 0
fi

# 3. Fall back to project-local prettier.
if [ -x "$PROJECT_DIR/node_modules/.bin/prettier" ]; then
  "$PROJECT_DIR/node_modules/.bin/prettier" --write "$FILE" >/dev/null 2>&1
  exit 0
fi

exit 0
