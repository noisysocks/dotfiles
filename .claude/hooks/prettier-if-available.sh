#!/bin/bash
# Auto-format files with Prettier if available in the project

FILE=$(jq -r '.tool_input.file_path // empty')

if [ -z "$FILE" ]; then
  exit 0
fi

if [ -x "$CLAUDE_PROJECT_DIR/node_modules/.bin/prettier" ]; then
  "$CLAUDE_PROJECT_DIR/node_modules/.bin/prettier" --write "$FILE" >/dev/null 2>&1
fi

exit 0
