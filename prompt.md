---
commit_ref:
title: "Use new select database command"
author: "Janik von Rotz <login@janikvonrotz.ch>"
action: implement
state: completed
date_completed: 2026-10-29
harness: pi 1.4.0
model: Qwen/Qwen3.8-27B-FP8 (infomaniak)
input_tokens: 85585
output_tokens: 52036
---

# Use new select database command

Note: @Clanker refers to the "ai agent" (you) who is working on this prompt file.

@Clanker when working on this prompt file, make sure to:

- Read the `AGENTS.md` and `README.md` to get an understanding of the project
- Read entire task section and prepare a list of todos
- Update the todo list while working on task

## Task

When I run `install-pi` I get prompted for the KeePass database password.

Then the `get-pass-from-keepass` retrieves the api key. Every time the new command `select-keepass-database` called.

And this happens 3 times in total. Instead the database selection should happen once.

Run `select-keepass-database` first and then prompt for password.

Store the selection of `select-keepass-database`.

Then call `get-pass-from-keepass` with all the credentials required.

If necessary setup en vars to the "KEEPASS_DATABASE_FILE" and "KEEPASS_DATABASE_KEY_FILE" to pass the selection.

@Clanker When task is completed set frontmatter state to review. Prompt the author to verify the results.

## Worklog

### Summary

**Root cause** — two compounding bugs:

1. In `taskfile.build` (commit `dd0ac45`) the KeePass utilities were migrated to lowercase `keepass_database_file`, but `select-keepass-database` still prints `KEEPASS_DATABASE_FILE=...` (uppercase). After the fzf selection the utilities therefore never saw the path and failed with `Keepass database file not found:` — this is why the HuggingFace/Scaleway lookups had to be commented out.
2. `install-pi` called `$(get-pass-from-keepass ...)` 3 times; each call runs in a subshell, so the selection never persisted and `select-keepass-database` (fzf) was triggered 3 times.

**Changes**

`taskfile.build` (library bugfix, same mechanical revert in all affected scripts):
- `bin/get-pass-from-keepass` plus `save-pass-to-keepass`, `save-dotenv-to-keepass`, `load-dotenv-from-keepass`, `save-kubeconfig-to-keepass`, `load-kubeconfig-from-keepass`, `store-agekey-to-keepass`, `load-agekey-from-keepass`, `show-project-setup`: use the uppercase `KEEPASS_DATABASE_FILE` / `KEEPASS_DATABASE_KEY_FILE` env vars again, matching the output of `select-keepass-database`. When the env vars are set and valid the database is **not** re-selected.
- `tests/test_sops`: removed the now-unneeded lowercase exports (the uppercase ones were already exported there).

`mint-system-dotfiles/task`:
- New `setup-keepass()` helper: runs `select-keepass-database` **once** (skipped when `KEEPASS_DATABASE_FILE` is already set and valid), stores the selection in `KEEPASS_DATABASE_FILE` / `KEEPASS_DATABASE_KEY_FILE`, drops stale/nonexistent values, exports both, and prompts for the database password **once** (`KEEPASS_DATABASE_PASSWORD`).
- `install-pi`: calls `setup-keepass` first, then reads all 3 credentials with `get-pass-from-keepass` (the commented-out HuggingFace + Scaleway lookups are restored).
- `install-llm`, `install-opencode`, `list-infomaniak-models`: same pattern, so the database is only selected once per run everywhere.

**Testing** (fake `keepassxc-cli` capturing its arguments, non-interactive):
- 20/20 checks pass: stored selection is respected without re-selecting; the install-pi sequence selects once and reads all 3 entries; pre-set env vars skip selection; a missing database fails cleanly; stale `KEEPASS_*` env vars are replaced by a fresh selection.
- `bash -n` + shellcheck (warning level) clean on all touched files.

**Note**: the current environment exports stale `KEEPASS_DATABASE_FILE` / `KEEPASS_DATABASE_KEY_FILE` pointing at `janikv.cloud/...` (path does not exist). `setup-keepass` now recovers from this automatically, but you may want to find where they are exported and remove them.

@Author please verify: run `./task install pi` and check that the database is selected once, the password is prompted once, and all 3 API keys are retrieved. If the results look good, confirm so I can mark this completed.

@Author confirmed on 2026-10-29: `./task install pi` selected the database once, prompted for the password once, retrieved all 3 API keys and wrote `~/.pi/agent/models.json` (the repeated `Enter password to unlock` lines are keepassxc-cli's own prompt while reading the piped password).

@Clanker If author confirms results set frontmatter state to completed, otherwise to aborted. Update date, harness and model. If you have access to session info also add token count.
