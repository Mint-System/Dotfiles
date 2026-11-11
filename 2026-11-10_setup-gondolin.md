---
commit_ref:
title: "Setup gondolin"
author: "Janik von Rotz <login@janikvonrotz.ch>"
action: implement
state: wip
date_completed: YYYY-MM-DD
harness:
provider:
model:
input_tokens:
output_tokens:
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

- `packages/gondolin`: installs the CLI with `pnpm add -g --ignore-scripts @earendil-works/gondolin`, installs the extension dependencies with `pnpm install --prefix pi/extensions`, symlinks `pi/extensions/gondolin.ts` to `~/.pi/agent/extensions/gondolin.ts` and warns when `/dev/kvm` is not writable (krun backend needs it, otherwise QEMU is required).
- `pi/extensions/gondolin.ts`: vendored from `host/examples/pi-gondolin.ts` at tag `v0.14.0`.
- `pi/extensions/package.json` + `pnpm-workspace.yaml`: local dependency on `@earendil-works/gondolin@^0.14.0`; `ssh2` native build disabled because it does not compile on the current Node.js.
- `pi/settings.json`: extension registered via `extensions: ["~/.pi/agent/extensions/gondolin.ts"]`.
- `.gitignore`: added `tmp`, `.env`, `node_modules`.
- `CHANGELOG.md`: entry under Unreleased/Added.

### Verification

- `./task install gondolin` exits 0, `gondolin` is on PATH and `gondolin list` works.
- Symlink `~/.pi/agent/extensions/gondolin.ts` points into this repo.

### Known limitations

- Booting a VM could not be verified in this environment: `qemu-img` is not installed (needed for the default `cow` rootfs mode) and the krun backend aborts with `virtio bridge error`/panic here. The user is also not in the `kvm` group. Installing QEMU and/or adding the user to `kvm` is required before `gondolin exec` can be tested.

## WIP

The extension loads, but every `bash`/`read`/`write`/`edit` tool call fails with:

```
Error: spawnSync qemu-img ENOENT
```

Cause: `VM.create()` in `@earendil-works/gondolin@0.14.0` always calls `prepareOverlayRootDisk()` → `ensureQemuImgAvailable()` (`dist/src/vm/core.js:287-315`, `1663-1673`). The rootfs mode is read from `options.rootfs?.mode` (VM option, not `sandbox`), from the image manifest `runtimeDefaults.rootfsMode`, or defaults to `cow`. The cached image manifest (`~/.cache/gondolin/images/objects/f59d9a69-.../manifest.json`) has no `runtimeDefaults`, so `cow` is used and `qemu-img` is mandatory.

Findings:

- `rootfs: { mode: "readonly" }` at the VM level also failed in the earlier probe (needs re-checking with the current code path).
- The krun backend (`sandbox.vmm: "krun"`) avoids QEMU for booting but still needs `qemu-img` for the overlay, and previously aborted with `virtio bridge error: read ECONNRESET`.
- `qemu-img` and `qemu-system-x86_64` are not installed on the host.

Next steps to try:

1. Install QEMU (`sudo pacman -S qemu-full`) and add the user to the `kvm` group, then re-test `gondolin exec`.
2. Or patch the vendored `pi/extensions/gondolin.ts` to pass `rootfs: { mode: "readonly" }` / `"memory"` at the VM level and verify whether that avoids `qemu-img`.
3. Optionally make `packages/gondolin` install QEMU as a dependency.

@Clanker If author confirms results set frontmatter state to completed, otherwise to aborted. Update date, harness, provider and model. If you have access to session info also add token count.
