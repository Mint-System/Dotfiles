---
title: "Update Infomaniak models"
author: "Janik von Rotz <login@janikvonrotz.ch>"
action: implement
state: completed
date_completed: 2026-10-22
harness: pi 1.3.0
model: deepseek-v4-flash-0731 (scaleway)
input_tokens: n/a
output_tokens: n/a
---

# Update Infomaniak models

Note: @Clanker refers to the "ai agent" (you) who is working on this prompt file.

@Clanker when working on this prompt file, make sure to:

- Read context and task section first
- Prepare a list of todos
- Update the todo list while working on task

## Context

@Clanker Read the `AGENTS.md` and `README.md` to get an understanding of the project.

## Task

I received a mail from Infomaniak:

```


Im Rahmen des Lebenszyklus der KI-Modelle informieren wir Sie, dass das folgende Modell ab dem 23.11.2026 nicht mehr verfügbar sein wird.
 

Sie können es ab sofort durch das unten aufgeführte gleichwertige Modell ersetzen.
 

Betroffenes Modell
 

Abkündigung von Qwen/Qwen3.5-122B-A10B-FP8. Sie können es durch Qwen/Qwen3.8-27B ersetzen.
 

Erforderliche Massnahme
 

In unserer Anleitung erfahren Sie, wie Sie die Aktualisierung Ihrer Anwendungen vorbereiten.
 

Wir danken Ihnen für Ihr Vertrauen und sind jederzeit für Sie da,
```

Update the `pi/models.json` and the `llm/extra-openai-models.yaml` with the new model.

@Clanker When task is completed set frontmatter state to review. Prompt the author to verify the results.

## Worklog

Replaced the deprecated Infomaniak model `Qwen/Qwen3.5-122B-A10B-FP8` with its successor in:

- `pi/models.json` (Infomaniak provider, `id` and `name` updated)
- `llm/extra-openai-models.yaml` (`model_id` and `model_name` updated)

Note: The email named the replacement `Qwen/Qwen3.8-27B`, but the Infomaniak API rejected that id (`validation_failed`). The API's allowed values show the correct id is `Qwen/Qwen3.8-27B-FP8` (the friendly display name stays `Qwen3.8-27B`).

@Clanker If author confirms results set frontmatter state to completed, otherwise to aborted. Update date, harness and model. If you have access to session info also add token count.
