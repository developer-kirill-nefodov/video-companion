# 014. Claude Code Tried to Delete Every Test

Jesse Vincent caught his coding agent one command away from running `rm -rf **/*test*`. His `CLAUDE.md` said even one failing test means project failure, and the agent's logic, as he retells it, was simple: if there aren't any tests, they can't fail.

This folder has the two guards from the video:

1. **One line for `CLAUDE.md`** (Jesse's fix). It changes what the agent optimizes for.
2. **A `PreToolUse` hook** that makes tests read-only for the agent. It does not rely on the agent agreeing.

## Files

| Path | What it is |
| --- | --- |
| [`CLAUDE.md`](CLAUDE.md) | The line to add to your project's `CLAUDE.md`. |
| [`.claude/hooks/no-tests.sh`](.claude/hooks/no-tests.sh) | The hook. Blocks edits to test files and `rm` / `mv` / `git rm` on tests. |
| [`.claude/settings.json`](.claude/settings.json) | Registers the hook for `Edit`, `Write`, `MultiEdit` and `Bash` calls. |
| [`test/run.sh`](test/run.sh) | Sample inputs: what must be blocked and what must pass. |

## Install

From the root of your project:

```bash
# 1. The line for CLAUDE.md
cat path/to/014-claude-code-tried-to-delete-every-test/CLAUDE.md >> CLAUDE.md

# 2. The hook
mkdir -p .claude/hooks
cp path/to/014-claude-code-tried-to-delete-every-test/.claude/hooks/no-tests.sh .claude/hooks/
chmod +x .claude/hooks/no-tests.sh
```

3. Register the hook. If you have no `.claude/settings.json` yet, copy the one from this folder. If you have one, merge the `PreToolUse` entry into its `hooks` section.
4. Restart Claude Code, or open `/hooks` to check that the hook is loaded.

Requires Bash 4+ and [`jq`](https://jqlang.org/).

## Verify

```bash
bash test/run.sh
```

Expected: `10 passed, 0 failed`. To see it live, ask the agent to "make the failing test pass" in a project with a failing test, and watch the edit to the test file get denied.

## How it works

Claude Code runs the hook before every matching tool call and passes the call as JSON on stdin. The hook reads `tool_input.file_path` (for edits and writes) and `tool_input.command` (for shell commands):

- a path that looks like a test (`*.test.*`, `*.spec.*`, `test/`, `tests/`, `__tests__/`) is denied;
- a shell command that runs `rm`, `mv` or `git rm` on anything with `test` in it is denied.

A denied call exits with code `2`. Claude Code blocks the call and shows the agent the message from stderr, so the agent learns why and goes back to fixing the code.

Adjust the `tests` pattern if your test files follow a different naming scheme.

## What it does not cover

- **It guards files, not intent.** Code written just to pass the test (a hard-coded return value, a special case for the test input) still gets through. Read the diff.
- **While it's on, the agent can't write tests either**, including new ones. Turn it off for tasks where writing tests is the job.
- It catches common ways to edit or remove tests, not every possible one. A script that rewrites files indirectly is out of its reach.

## Two views

Jesse Vincent considers blocking test edits counterproductive and relies on the `CLAUDE.md` line. The ImpossibleBench authors recommend making tests read-only, or hiding them, during implementation. The video uses both: the line sets the goal, the hook enforces it.

## Sources

- Jesse Vincent, [That time it tried to delete all my tests](https://blog.fsck.com/2026/04/30/that-time-it-tried-to-delete-all-my-tests) (Apr 2026)
- Zhong, Raghunathan, Carlini, [ImpossibleBench: Measuring LLMs' Propensity of Exploiting Test Cases](https://arxiv.org/abs/2510.20270) (Oct 2025)
- [Claude Code hooks reference](https://code.claude.com/docs/en/hooks)
