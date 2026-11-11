# AGENTS.md

Note: @Clanker refers to the "ai agent" (you) who is working on this task.

## General

This section outlines the universal rules and expectations for any LLM agent working within this repository.

**Safety and Quality First:** The highest priority is to produce secure, well-documented, and high-quality code. Do not introduce vulnerabilities, hardcoded secrets, or unreadable code.

**Propose a Plan:** For any new task, first provide a brief plan of action. This plan should clearly outline the intended changes and the rationale behind them.

**Maintain Context:** Before making any changes, an agent must read and understand the relevant files, including the project's main documentation and existing code structure.

**Be Sparse:** Only introduce new code if needed. Comment only what is worth commenting. When testing focus on the business use case. When writing documentations keep the explanation to a minimum.

**Never Commit:** Do not run `git commit`, `git push`, or any other version control write operation. Only the author is allowed to commit changes. You may stage files, run diffs, and prepare commit messages, but the actual commit and push must be done by the author.

## Project

@Clanker document the structure of this project in this section.

## Environment

### Taskfile

This project uses the <https://taskfile.build/> standard.

The `./task` file is a bash script that provides all functions necessary to work with this project.

Always try to run a command with the `./task` file script.

### New packages

Do not automatically install new software packages. Always ask for permission.

### Prompt WIP

Tasks are tracked in `prompt.md` with a frontmatter state of `draft`, `wip`, `review`, `completed` or `cancelled`.

When the author tells you to stop (e.g. "stop" or "continue later"), preserve your work in progress:

- Add a `## WIP` section to `prompt.md` and capture the current progress there.
- Set the frontmatter state to `wip`.
- Store the prompt with `./task commit-prompt`.

When you resume work on a `wip` prompt, read the `## WIP` section and continue from there.

### Session Info (Pi harness)

Inside the **Pi** harness, session details are exposed as environment variables:

- `PI_MODEL` – model ID, e.g. `deepseek-v4-1-flash-1017`
- `PI_PROVIDER` – provider, e.g. `mistral`
- `PI_REASONING_LEVEL` – e.g. `off`
- `PI_SESSION_ID` – e.g. `01a1a57c-a4b1-777f-ac7b-6b912be9400a`
- `PI_SESSION_FILE` – path to the session log, e.g. `$HOME/.pi/agent/sessions/*/2026-11-04T07-36-11-698Z_01a1a57c-a4b1-777f-ac7b-6b912be9400a.jsonl`
- `AI_AGENT` – e.g. `Pi`
- `PI_CODING_AGENT` – e.g. `true`

The session log at `$PI_SESSION_FILE` is a JSONL file. Each assistant message carries token usage in `message.usage` (`input` and `output`). When completing a prompt file, extract the model and cumulative token counts from these sources:

```bash
jq -s '[.[] | select(.type == "message" and .message.usage) | .message.usage]
  | {input: (map(.input) | add // 0), output: (map(.output) | add // 0)}' "$PI_SESSION_FILE"
```

This prints the totals, e.g. `{"input": 19876, "output": 1064}`.

If `jq` is unavailable (e.g. inside a Gondolin micro-VM), use `node`:

```bash
node -e 'const l=require("fs").readFileSync(process.env.PI_SESSION_FILE,"utf8").split("\n").filter(Boolean);let i=0,o=0;for(const x of l){const m=JSON.parse(x);if(m.type==="message"&&m.message?.usage){i+=m.message.usage.input||0;o+=m.message.usage.output||0}}console.log(JSON.stringify({input:i,output:o}))'
```

### Temporary files

When creating temporary files and scripts, use the `./tmp` directory.

## Conventions

@Clanker document project specific coding conventions in this section.

