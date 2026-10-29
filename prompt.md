---
title: "Use new select database command"
author: "Janik von Rotz <login@janikvonrotz.ch>"
action: implement
state: draft
date_completed: YYYY-MM-DD
harness:
model:
input_tokens:
output_tokens:
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

@Clanker Add a summary here once the task has been completed.

@Clanker If author confirms results set frontmatter state to completed, otherwise to aborted. Update date, harness and model. If you have access to session info also add token count.
