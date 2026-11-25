#!/usr/bin/env bash
# Feeds sample PreToolUse inputs to the hook and checks the exit codes: 2 = blocked, 0 = allowed.
set -u
hook="$(cd "$(dirname "$0")/.." && pwd)/.claude/hooks/no-tests.sh"
pass=0
fail=0

check() {
  local want=$1 name=$2 input=$3
  printf '%s' "$input" | bash "$hook" 2>/dev/null
  local got=$?
  if [[ $got -eq $want ]]; then
    pass=$((pass + 1))
    printf 'ok    %s\n' "$name"
  else
    fail=$((fail + 1))
    printf 'FAIL  %s (want %s, got %s)\n' "$name" "$want" "$got"
  fi
}

edit() { printf '{"tool_name":"Edit","tool_input":{"file_path":"%s"}}' "$1"; }
bash_cmd() { printf '{"tool_name":"Bash","tool_input":{"command":"%s"}}' "$1"; }

check 2 'edit a test file'            "$(edit src/price.test.ts)"
check 2 'edit a spec file'            "$(edit app/user.spec.js)"
check 2 'edit inside tests/'          "$(edit tests/helpers.py)"
check 2 'edit inside __tests__/'      "$(edit src/__tests__/cart.tsx)"
check 0 'edit application code'       "$(edit src/price.ts)"
check 2 'rm -rf every test'           "$(bash_cmd 'rm -rf **/*test*')"
check 2 'git rm a test file'          "$(bash_cmd 'git rm src/price.test.ts')"
check 2 'mv a test away'              "$(bash_cmd 'cd app && mv tests/a.py /tmp/')"
check 0 'run the tests'               "$(bash_cmd 'npm test')"
check 0 'rm something else'           "$(bash_cmd 'rm -rf dist')"

printf '\n%s passed, %s failed\n' "$pass" "$fail"
[[ $fail -eq 0 ]]
