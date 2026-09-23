---
title: "Create scripts for checkin and checkout attendance in Odoo"
state: completed
date_completed: 2026-09-23
model: moonshotai/Kimi-K2.6
input_tokens: 1619604
output_tokens: 27365
---

# Run 02

Note: @Clanker refers to the "ai agent" (you) who is working on this task.

@Clanker when working on this task, make sure to:

- Read context and task section first
- Prepare a list of todos
- Update the todo list while working on the task

## Context

@Clanker Read the `AGENTS.md` and `README.md` to get an understanding of the project.

## Task

I want to be able to run `checkin-odoo erp.mint-system.ch` and `checkout-erp.mint-system.ch` on the command line.

Create a single uv Python script `./bin/checkin-checkout-odoo` that toggles attendance status. This script takes `<env>` as param.

These script use the Odoo XML-RPC api to call the checkin and checkout actions of Odoo.

The libraries required to make the connection have to be added as dependency like this:

```python
#!/usr/bin/env -S uv run --script
# /// script
# dependencies = [
#   "networkx",
#   "jinja2",
# ]
# ///

from jinja2 import Template
```

The access credentials are loaded with `load-dotenv <env>`. This bash function can imported from taskfile.build. See the `task` script for details.

Add a command `task copy-bin` that copies the content of `./bin` to `$HOME/.local/bin`.

You can test the script with the `erp.mint-system.ch` credentials.

## Worklog

Created `./bin/checkin-checkout-odoo`, a single uv Python script that toggles attendance status:
- If the user has an open attendance record (`check_out` is False), it checks them out and prints the logout time plus worked duration.
- If the user has no open attendance record, it checks them in and prints the new attendance ID.

The script:
- Accepts `<env>` as the first positional argument.
- Uses the inline uv script shebang (`#!/usr/bin/env -S uv run --script`) with an empty dependency block (stdlib `xmlrpc.client` and `datetime` are sufficient).
- Loads credentials by shelling out to the taskfile.build `load-dotenv` function and importing the resulting environment variables into the Python process.
- Respects the existing `TASK_DOTENV_DIR` environment variable (falls back to `~/.config/taskfile.build`), so it works out of the box with the user's actual dotenv directory.
- Validates that the env file exists before attempting to load it.

Added `copy-bin` to `./task`:
- Copies all files from `./bin/` to `$HOME/.local/bin` with executable permissions.
- Registered in the help table.

**Testing results:**
- `./bin/checkin-checkout-odoo erp.mint-system.ch` (not checked in) → `Checked in. Attendance ID: 550`
- `./bin/checkin-checkout-odoo erp.mint-system.ch` (checked in) →
  ```
  Checked out at 12:38:33
  0 minutes
  ```
