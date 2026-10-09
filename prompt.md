---
title: "Add support for Scaleway provider and models to Pi"
author: "Janik von Rotz <login@janikvonrotz.ch>"
state: completed
date_completed: 2026-10-09
model: moonshotai/Kimi-K2.6
input_tokens:
output_tokens:
---

# Add support for Scaleway provider and models to Pi

Note: @Clanker refers to the "ai agent" (you) who is working on this prompt file.

@Clanker when working on this prompt file, make sure to:

- Read context and task section first
- Prepare a list of todos
- Update the todo list while working on task

## Context

@Clanker Read the `AGENTS.md` and `README.md` to get an understanding of the project.

## Task

I have prepared the `task install-pi` task to add the Scaleway api key. 

Update `pi/models.json` to support this model:

```
curl https://api.scaleway.ai/3bce0d2a-aa5e-44d4-9a8d-b3a71babdd93/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $SCW_SECRET_KEY" \
  -d '{
    "max_tokens": 2048,
    "messages": [
      {
        "content": "",
        "role": "user"
      }
    ],
    "model": "deepseek-v4-flash-0731",
    "presence_penalty": 0,
    "reasoning_effort": "high",
    "response_format": {
      "type": "text"
    },
    "stream": false,
    "temperature": 1,
    "top_p": 1
  }'
```

## Worklog

- Added `scaleway` provider to `pi/models.json` with `deepseek-v4-flash-0731` model using the OpenAI-compatible completions API.
- Fixed typo in `task` install-pi function: `SACLEWAY_API_KEY` → `SCALEWAY_API_KEY` and updated the `envsubst` variable list accordingly.

@Clanker Set frontmatter state to completed and update date and model. If you have access to session info also add token count.
