# Video Companion

Code from the videos of **Kirill Nefodov Engineering**: the hooks, configs and scripts shown on screen, ready to copy into your own project.

The channel looks at real incidents with AI coding agents (Claude Code, Codex, Cursor) and at the small guards that would have stopped them. A video shows a guard working. This repository holds the exact files, with install steps and a way to check them yourself.

## Episodes

| # | Video | What's inside |
| --- | --- | --- |
| 014 | Claude Code Tried to Delete Every Test | A `PreToolUse` hook that makes test files read-only for the agent, the one line for `CLAUDE.md`, and a test script. [Open](episodes/014-claude-code-tried-to-delete-every-test) |

## How this repository is organized

```
episodes/
  <number>-<video-slug>/
    README.md        what it does, install, verify, limits, sources
    ...              the files exactly as they appear in the video
    test/            a script that checks the guard on sample inputs
```

- **One folder per video.** The number matches the episode number in the video description, so a link from the video lands in the right folder.
- **Files keep their real paths.** A file that lives in `.claude/hooks/` in your project lives in `.claude/hooks/` here too, so you can copy the folder structure as is.
- **Every guard ships with a check.** `test/run.sh` feeds it sample inputs and prints what was blocked and what was allowed. Run it before you trust the guard.
- **Every README states the limits.** A guard covers one failure mode. The "What it does not cover" section says what is still on you.

## Using the files

1. Open the episode folder and read its README first: the install steps differ per tool.
2. Copy the files into your project, keeping the paths.
3. Run the episode's `test/run.sh` to see the guard work on your machine.
4. Commit the guard so everyone on the team, and every agent session, gets it.

Read every script before you run it. These are small, focused examples, not a framework: adapt the patterns to your repository layout.

## Requirements

Most guards are plain Bash with [`jq`](https://jqlang.org/). Each episode README lists anything else it needs.

## Feedback

Found a case a guard misses, or a cleaner way to write it? Open an issue with the input that slipped through. Real failure cases are the most useful thing you can send.

## License

[MIT](LICENSE). Use the files in your own and commercial projects.
