#!/bin/bash
# Claude Code status line
# Shows: project dir (git branch) | model (effort) | tokens used | session cost
# Managed by the statusline-setup agent.

input=$(cat)

DIM=$'\033[2m'
RESET=$'\033[0m'
YELLOW=$'\033[33m'
RED=$'\033[31m'

model=$(printf '%s' "$input" | jq -r '.model.id // "unknown"')
effort=$(printf '%s' "$input" | jq -r '.effort.level // empty')
project_dir=$(printf '%s' "$input" | jq -r '.workspace.project_dir // empty')
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // empty')

project_name=""
[ -n "$project_dir" ] && project_name=$(basename "$project_dir")

git_dir="${cwd:-$project_dir}"
branch=""
[ -n "$git_dir" ] && branch=$(git --no-optional-locks -C "$git_dir" branch --show-current 2>/dev/null)

input_tokens=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // 0')
output_tokens=$(printf '%s' "$input" | jq -r '.context_window.total_output_tokens // 0')
total_tokens=$((input_tokens + output_tokens))

cost=$(printf '%s' "$input" | jq -r '.cost.total_cost_usd // empty')

# compact token formatting (e.g. 1234 -> 1.2k)
if [ "$total_tokens" -ge 1000 ]; then
  tokens_fmt=$(awk -v n="$total_tokens" 'BEGIN{printf "%.1fk", n/1000}')
else
  tokens_fmt="$total_tokens"
fi

dir_segment="$project_name"
[ -n "$branch" ] && dir_segment="$dir_segment ($branch)"

segments=()
[ -n "$dir_segment" ] && segments+=("$dir_segment")

model_segment="$model"
[ -n "$effort" ] && model_segment="$model_segment ($effort)"
segments+=("$model_segment")

line=""
for seg in "${segments[@]}"; do
  if [ -z "$line" ]; then
    line="$seg"
  else
    line="$line | $seg"
  fi
done

if [ "$total_tokens" -ge 500000 ]; then
  token_segment="${RED}${tokens_fmt}${RESET}${DIM}"
elif [ "$total_tokens" -ge 200000 ]; then
  token_segment="${YELLOW}${tokens_fmt}${RESET}${DIM}"
else
  token_segment="${tokens_fmt}"
fi

line="$line | $token_segment"

if [ -n "$cost" ]; then
  cost_fmt=$(awk -v c="$cost" 'BEGIN{printf "$%.2f", c}')
  line="$line | $cost_fmt"
fi

printf "%s%s%s\n" "$DIM" "$line" "$RESET"
