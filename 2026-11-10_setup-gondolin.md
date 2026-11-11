---
commit_ref: 117887fcd0aceca9c335470876ab331fd07d0fc6
title: "Setup gondolin"
author: "Janik von Rotz <login@janikvonrotz.ch>"
action: implement
state: completed
harness: Pi
provider: mistral
model: deepseek-v4-1-flash-1017
input_tokens: 1518831
output_tokens: 33142
---

# Setup gondolin

Note: @Clanker refers to the "ai agent" (you) who is working on this prompt file.

@Clanker when working on this prompt file, make sure to:

- Read the `AGENTS.md` and `README.md` to get an understanding of the project
- Read entire task section and prepare a list of todos
- Update the todo list while working on task

## Task

Create a `packages/gondolin` that installs https://github.com/earendil-works/gondolin

Also setup the Pi extension https://github.com/earendil-works/gondolin

@Clanker When task is completed set frontmatter state to review. Prompt the author to verify the results.

## Worklog

@Clanker Add a summary here once the task has been completed.

### Implementation

- `packages/gondolin`: installs the CLI with `pnpm add -g --ignore-scripts @earendil-works/gondolin`, installs the extension dependencies with `pnpm install --prefix pi/extensions`, symlinks `pi/extensions/gondolin.ts` to `~/.pi/agent/extensions/gondolin.ts` and warns when QEMU is missing.
- `packages/qemu`: installs headless QEMU (`qemu-base` on pacman, `qemu-system-x86` + `qemu-utils` on apt) and verifies `qemu-img` and `qemu-system-x86_64`.
- `pi/extensions/gondolin.ts`: vendored from `host/examples/pi-gondolin.ts` at tag `v0.14.0`.
- `pi/extensions/package.json` + `pnpm-workspace.yaml`: local dependency on `@earendil-works/gondolin@^0.14.0`; `ssh2` native build disabled because it does not compile on the current Node.js.
- `pi/settings.json`: extension registered via `extensions: ["~/.pi/agent/extensions/gondolin.ts"]`.
- `.gitignore`: added `tmp`, `.env`, `node_modules`.
- `CHANGELOG.md`: entry under Unreleased/Added.

### Verification

- `./task install gondolin` exits 0, `gondolin` is on PATH and `gondolin list` works.
- Symlink `~/.pi/agent/extensions/gondolin.ts` points into this repo.
- `./task install qemu` installs QEMU 11.1.3; `qemu-img` and `qemu-system-x86_64` are on PATH.
- `gondolin exec -- echo hello-from-gondolin` prints `hello-from-gondolin`.
- `VM.create({ vfs: { mounts: { "/workspace": new RealFSProvider(cwd) } } })` (same call the Pi extension makes) boots and lists the mounted workspace.

### Notes

- QEMU is the default backend and is required: `VM.create()` uses the `cow` rootfs mode unless the VM option or image manifest says otherwise, which needs `qemu-img` for the overlay.
- The `krun` backend is not usable on this host. The bundled runner panics with `Kernel doesn't fit in RAM` at the default 1024 MiB; raising `memory` avoids the panic but it still dies with `virtio bridge error: read ECONNRESET`. Upstream marks krun as experimental.
- `rootfs: { mode: "readonly" }` avoids `qemu-img` but makes the guest root filesystem immutable, so it is not suitable for the extension.

@Clanker If author confirms results set frontmatter state to completed, otherwise to aborted. Update date, harness, provider and model. If you have access to session info also add token count.


### Session env in the guest (was WIP)

Agents running inside the VM saw `PI_MODEL` and `PI_SESSION_FILE` empty, so they could not read their own session log for token counts. `/sessions` was mounted correctly all along.

Root cause: Pi **scrubs** `PI_SESSION_ID`, `PI_SESSION_FILE`, `PI_PROVIDER`, `PI_MODEL` and `PI_REASONING_LEVEL` from `process.env` and re-injects them only into its own bash tool env. The extension's custom `BashOperations` bypassed that path. `PI_CODING_AGENT` worked because it is never scrubbed.

Fix: `pi/extensions/gondolin.ts` now reads the values from `ctx` (`sessionManager.getSessionFile()`, `getSessionId()`, `model`, `thinkingLevel`) — the same source Pi's own bash tool uses — and rewrites the host session path into the `/sessions` mount. `/sessions` is mounted read-only via `ReadonlyProvider`, as a folder so it survives new sessions and `/resume`.

Rejected approaches (do not repeat): reading `process.env` at extension load time (always empty), and a `spawnHook` returning an `export ...` prefix (the hook `env` is ignored by custom `operations`).

Verified end-to-end: this session runs inside the micro-VM (`uname` reports `6.18.58-0-virt`, `/workspace` and `/sessions` are `sandboxfs` FUSE mounts) and the guest reports `PI_SESSION_FILE=/sessions/--home-janikvonrotz-mint-system-dotfiles--/2026-11-11T14-34-00-639Z_01a1cb07-....jsonl`, `PI_MODEL=deepseek-v4-1-flash-1017`, `PI_PROVIDER=mistral`, `PI_REASONING_LEVEL=off`. The token recipe in `AGENTS.md` runs against that path.

### Host verification (after the VM work)

Re-ran the install on the host, because the earlier verification happened inside the micro-VM and the host state had drifted:

- `gondolin` was **not** on PATH and the `~/.pi/agent/extensions/gondolin.ts` symlink was **missing**. Re-ran `./task install gondolin`; CLI at `~/.local/share/pnpm/bin/gondolin`, symlink restored.
- `gondolin list` → `No running sessions.`; QEMU present.
- `VM.create()` with the same `RealFSProvider` mount the extension uses boots: guest `uname -r` = `6.18.58-0-virt`, `/workspace` lists the repo.
- All four `pi/extensions/*` files are tracked despite `pnpm-workspace.yaml` being in `.gitignore`.
- `packages/qemu` has mode `644` while every other `packages/*` script is `755`. Harmless (`task` uses `source`), left as is.

### Upstream contribution

Asked whether the extension changes were worth a pull request. Diffed `pi/extensions/gondolin.ts` against `host/examples/pi-gondolin.ts`: upstream `main` (`7ef9c13`) is byte-identical to the v0.14.0 copy, so none of it exists upstream. Only the session-env fix is upstream-worthy; the header/install-comment edits are specific to this repo.

Found while checking for duplicates (no existing issue covered it):

- **PR #172** (open) adds `GONDOLIN_DISABLED=1` to the example — the same need as the local `pwp -g` flag, but better (keeps other extensions and builtins).
- **PR #125** (open) ships the extension via `pi.extensions` and moves it to `host/extensions/`.

Filed **issue #205** (`tmp/gondolin-issue.md`) and opened **PR #207** (`tmp/gondolin-pr-body.md`, `tmp/gondolin-session-env.patch`). The patch is env-allowlist only, `+36/−4`, and deliberately excludes the `/sessions` mount and path rewrite — the issue raises that as an open design question so the PR stays reviewable. Verified by temporarily swapping the patched upstream file into the installed extension: the guest then reports `PI_MODEL`, `PI_PROVIDER`, `PI_SESSION_ID` and `PI_REASONING_LEVEL`.

PR history: #206 was opened first from the personal fork, then closed and recreated as #207 from `Mint-System/gondolin` (GitHub cannot retarget a PR's head repo). Comments were removed from the TS file at the author's request — the rationale lives in the PR body instead — and the two commits were squashed into one.

### `prompt-with-pi -g` (taskfile.build)

Added a `-g` / `--no-gondolin` flag to `~/taskfile.build/bin/prompt-with-pi` to run Pi on the host.

Two approaches that do **not** work, proven with an isolated `PI_CODING_AGENT_DIR` probe:

- `--no-extensions` alone drops every extension, not just gondolin.
- A project-level `-path` exclusion (`{"extensions": ["-~/.pi/agent/extensions/gondolin.ts"]}`) does **not** disable a user-level extension. The docs claim `-path` works, but it only filters within one settings layer, and project settings need `--approve` to be read at all.

What it does: `-ne` plus `-e` for each configured package, read from `.packages[]` by a new `get-pi-packages` helper (honors `PI_CODING_AGENT_DIR`, no-ops without `jq`). Gondolin lives in `extensions`, so it is the only thing dropped. Caveat: builtins such as `builtin:codemode` are disabled too.

Verified: `pwp` → guest `6.18.58-0-virt`; `pwp -g` → host `7.2.14-arch1-1`. `shellcheck bin/prompt-with-pi` clean.

Docs updated: `docs/library.md` (help row + paragraph), `task.template` (regenerated via `./task update-task-template-help`, one-line diff), `CHANGELOG.md`.

### Open follow-ups

- `~/taskfile.build/templates/AGENTS.md.session-info` gained a `node` fallback for the token recipe (the guest has no `jq`); `AGENTS.md` in this repo carries the same paragraph. 12 other repos still have the older prose-only session-info section and 4 have the `jq`-only recipe; re-render them with `./task template-project-agents` (interactive `fzf`, verify no section is dropped).
- `prompt-with-pi -g` becomes redundant if upstream #172 merges; switch to `GONDOLIN_DISABLED=1` then, since it keeps other extensions and builtins.
- PR #207 needs rebasing onto `host/extensions/` if #125 lands first.
- `CONTRIBUTING.md` does not exist upstream although the PR template references it.
- The personal fork `janikvonrotz/gondolin` and its branch are orphaned since #206 closed; delete or keep as a backup.
- `packages/qemu` mode `644` vs `755` on the other package scripts.
