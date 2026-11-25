#!/usr/bin/env bash
# PreToolUse hook, matcher: Edit|Write|MultiEdit|Bash
# Tests are read-only for the agent: no edits, no rm/mv.
in=$(cat)
path=$(jq -r '.tool_input.file_path // empty' <<<"$in")
cmd=$(jq -r '.tool_input.command // empty' <<<"$in")
tests='(^|/)(tests?|__tests__)/|\.(test|spec)\.'
if [[ -n $path && $path =~ $tests ]]; then
  echo "Tests are read-only. Fix the code, not $path." >&2
  exit 2
fi
del='(^|[;&|[:space:]])(rm|mv|git[[:space:]]+rm)[[:space:]]'
if [[ $cmd =~ $del && $cmd =~ test ]]; then
  echo "Deleting tests is blocked. Make them pass." >&2
  exit 2
fi
exit 0
