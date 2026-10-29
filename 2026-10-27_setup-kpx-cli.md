---
commit_ref:
title: "Setup kpx-cli"
author: "Janik von Rotz <login@janikvonrotz.ch>"
action: implement
state: draft
date_completed: YYYY-MM-DD
harness:
model:
input_tokens:
output_tokens:
---

# Setup kpx-cli

Note: @Clanker refers to the "ai agent" (you) who is working on this prompt file.

@Clanker when working on this prompt file, make sure to:

- Read context and task section first
- Prepare a list of todos
- Update the todo list while working on task

## Context

@Clanker Read the `AGENTS.md` and `README.md` to get an understanding of the project.

## Task

### Install command

In `tmp/prompt-log/2026-10-27_get-database-path-from-running-keepassxc.md` I learned about the `kpx-cli` / https://github.com/LavieX/kpx . Please add a `install-kpx` task.

### Taskfile commands

Then I want you to update the keepass command to use the `kpx` cli:

```
[main][~/taskfile.build]$ fd -g "*keepass*"
bin/get-pass-from-keepass
bin/load-agekey-from-keepass
bin/load-dotenv-from-keepass
bin/load-kubeconfig-from-keepass
bin/save-dotenv-to-keepass
bin/save-kubeconfig-to-keepass
bin/save-pass-to-keepass
bin/store-agekey-to-keepass
```

### Documentation

Document kpx as requirement in `~/taskfile.build/docs/library.md`.

### Testing

Once the kpx cli and new commands are ready, I will test it by running:

```
cd ~/Wiki
task store-agekey-to-keepass
task load-agekey-from-keepass
```

### Docs

If this works you can move any mentions of `KEEPASS_DATABASE_FILE` and `KEEPASS_DATABASE_KEY_FILE` in this project and in `~/taskfile.build`.

Also update instructions `README.md`. 

@Clanker When task is completed set frontmatter state to review. Prompt the author to verify the results.

## Worklog

@Clanker Add a summary here once the task has been completed.

@Clanker If author confirms results set frontmatter state to completed, otherwise to aborted. Update date, harness and model. If you have access to session info also add token count.
