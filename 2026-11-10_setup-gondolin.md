---
commit_ref: d8bd3662f25542a75c46e1e0ebb59a1a9bd10dd6
title: "Setup gondolin"
author: "Janik von Rotz <login@janikvonrotz.ch>"
action: implement
state: completed
date_completed: 2026-11-11
harness: Pi
provider: mistral
model: deepseek-v4-1-flash-1017
input_tokens: 438809
output_tokens: 13795
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
