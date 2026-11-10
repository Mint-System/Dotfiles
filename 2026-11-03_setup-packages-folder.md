---
commit_ref: 9a3bfb9952f781c2aa336cca0ffde499373357e7
title: "Setup packages folder"
author: "Janik von Rotz <login@janikvonrotz.ch>"
action: implement
state: completed
date_completed: 2026-11-03
harness: pi 1.5.0
model: deepseek-v4-1-flash-1017 (mistral)
input_tokens: 25052
output_tokens: 8241
---

# Setup packages folder

Note: @Clanker refers to the "ai agent" (you) who is working on this prompt file.

@Clanker when working on this prompt file, make sure to:

- Read the `AGENTS.md` and `README.md` to get an understanding of the project
- Read entire task section and prepare a list of todos
- Update the todo list while working on task

## Task

In the task file are `install-*` functions for different packages. Instead of having all functions in this file I want have one package file in the `packages` folder.

I prepared an example `packages/pnpm`. Apply this pattern for all other packages.

Then in the `task` file source the `packages/*` folders.

While you are at it, sort the list of packages from the `list` command. 

@Clanker When task is completed set frontmatter state to review. Prompt the author to verify the results.

## Worklog

- Moved all `install-*` functions out of the `task` file into one file per package in `packages/` (age, exo, fzf, hcloud, helm, k9s, keepass, kind, kubectl, llm, nextcloud, npm, obsidian, opencode, openshift-cli, pi, pnpm, postgresql-client, sops, uv, yq), following the `packages/pnpm` pattern (shebang, one file per package, function body unchanged).
- `task` now sources every file in `packages/*` before the `taskfile.build` bin imports, so helper functions (`create-symlink`, `log-warning`, `setup-keepass`) and `PACKAGE_MANAGER` remain available to the package files.
- Each package file registers its own `list` row via `PACKAGE_ROWS+=("<name>|<description>")`, so adding a package file is enough to make it appear in `./task list`. The `list` command sorts the registered rows alphabetically at runtime; the hardcoded row list was removed from `task`.
- Side effect: `pi` was missing from the old hardcoded table and is now listed.
- Verified with `bash -n` on `task` and all package files, `./task list`, `./task help`, and a dispatch check that all 21 `install-<name>` functions resolve after sourcing.

@Clanker If author confirms results set frontmatter state to completed, otherwise to aborted. Update date, harness and model. If you have access to session info also add token count.
