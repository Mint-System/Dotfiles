---
commit_ref:
title: "Update Infomaniak models"
author: "Janik von Rotz <login@janikvonrotz.ch>"
action: implement
state: draft
date_completed: YYYY-MM-DD
harness:
model:
input_tokens:
output_tokens:
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

@Clanker Add a summary here once the task has been completed.

@Clanker If author confirms results set frontmatter state to completed, otherwise to aborted. Update date, harness and model. If you have access to session info also add token count.
