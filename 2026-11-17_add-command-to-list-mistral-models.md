---
commit_ref: 573dfb1b56de1f1a1499a4fa7c652b120851f002
title: "Add command to list mistral models"
author: "Janik von Rotz <login@janikvonrotz.ch>"
session_id: 01a1e969-d964-77dd-be08-fdddcba2b3c1
action: execute
state: completed
date_completed: 2026-11-17
harness: pi
provider: mistral
model: deepseek-v4-1-flash-1017
input_tokens: 20812
output_tokens: 5933
---

# Add command to list mistral models

Note: @Clanker refers to the "ai agent" (you) who is working on this prompt file.

@Clanker when working on this prompt file, make sure to:

- Read the `AGENTS.md` to get an understanding of the project
- Read task section and prepare a list of todos
- Update the todo list while working on task

## Task

Similar to `list-infomaniak-models` I want a `list-mistral-models` commands.

@Clanker When task is completed set frontmatter state to review. If you have access to session info add token count and session id. Prompt the author to verify the results.

## Worklog

@Clanker Add a summary here once the task has been completed.

@Clanker If author confirms results set frontmatter state to completed, otherwise to aborted. Update date, harness, provider and model. If you have access to session info update token count. Finally, update the changelog with the most important changes.

- Added `list-mistral-models` to `./task`: prompts for the KeePass database, reads the API key from `dotenv/mistral_api_key_${USER}` (same entry as `install-pi`) and prints the model IDs from `https://api.mistral.ai/v1/models` via `jq -r '.data[].id'`.
- Registered the command in the `help-table`.
- Verified with `bash -n task`, `./task help` and a stubbed dry run showing the curl call with the bearer token. `jq` is not installed in this container, so no live API call was made.
- Author confirmed `./task list-mistral-models` returns the full Mistral model list.
- Follow-up: added `mistral-code-latest` to the `mistral` provider in `pi/models.json` and to `llm/extra-openai-models.yaml`.
