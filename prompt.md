---
title: "pi no auto cmpacting"
author: "Janik von Rotz <login@janikvonrotz.ch>"
action: implement
state: completed
date_completed: 2026-10-27
harness: pi
model: moonshotai/Kimi-K2.6
input_tokens:
output_tokens:
---

# pi no auto cmpacting

Note: @Clanker refers to the "ai agent" (you) who is working on this prompt file.

@Clanker when working on this prompt file, make sure to:

- Read context and task section first
- Prepare a list of todos
- Update the todo list while working on task

## Context

@Clanker Read the `AGENTS.md` and `README.md` to get an understanding of the project.

## Task

Update `pi/settings.json` to disable auto compacting.

@Clanker When task is completed set frontmatter state to review. Prompt the author to verify the results.

# Worklog

Added `"compaction": { "enabled": false }` to `pi/settings.json` to disable automatic context compaction. Manual compaction with `/compact` remains available.

@Clanker If author confirms results set frontmatter state to completed, otherwise to aborted. Update date, harness and model. If you have access to session info also add token count.
