---
commit_ref:
title: "set max token settings"
author: "Janik von Rotz <login@janikvonrotz.ch>"
action: implement
state: review
date_completed: YYYY-MM-DD
harness:
model:
input_tokens:
output_tokens:
---

# set max token settings

Note: @Clanker refers to the "ai agent" (you) who is working on this prompt file.

@Clanker when working on this prompt file, make sure to:

- Read the `AGENTS.md` and `README.md` to get an understanding of the project
- Read entire task section and prepare a list of todos
- Update the todo list while working on task

## Task

When using pi and any model I often run into this issue: https://github.com/earendil-works/pi/issues/7855

It seems adding max token info to `pi/models.json` helps resolving this issue.

Get the max token info for all models and upate the file.

I will then `task install pi` and check if it works.

@Clanker When task is completed set frontmatter state to review. Prompt the author to verify the results.

## Worklog

@Clanker Add a summary here once the task has been completed.

## Summary

Filled in `contextWindow` and `maxTokens` for all 13 models in `pi/models.json` (they were previously commented out, which caused pi to fall back to defaults and hit the truncation issue described in https://github.com/earendil-works/pi/issues/7855).

Values were gathered from authoritative sources:

- **pi.dev catalog** (downloaded in `~/.pi/agent/models-store.json`) and the HuggingFace router for models also served there: `google/gemma-4-31B-it` (262144/32768), `moonshotai/Kimi-K2.6` (262144/262144), `moonshotai/Kimi-K2.7-Code` (262144/262144), `Qwen/Qwen3.5-397B-A17B-FP8` (262144/32768), `Qwen/Qwen3.8-27B-FP8` (262144/32768), `deepseek-v4-flash-0731` (1048576/384000).
- **Official model cards/papers**: Mistral Ministral-3 and Mistral-Small-4 (256k context), NVIDIA Nemotron-3-Nano-30B-A3B-FP8 (default 256k context), Apertus v1.5 paper (262,144 context; 16,384-token decode budget), Qwen3-Embedding-8B (32k sequence length).
- **Embedding models** got `contextWindow` only (they don't generate output): `bge_multilingual_gemma2` (8192), `mini_lm_l12_v2` (512), `Qwen/Qwen3-Embedding-8B` (32768).

Corrections vs. the previously commented-out guesses: `Qwen/Qwen3-Embedding-8B` context 40960 → 32768 (official spec is 32K), `Qwen/Qwen3.8-27B-FP8` maxTokens 65536 → 32768 (pi.dev catalog), `Apertus-v1.5-70B` maxTokens 8192 → 16384 (paper decode budget).

Verified: `pi/models.json` is valid JSON and `pi --list-models` shows the new context/max-out values for every model.

@Author: Please run `task install pi` and verify the truncation issue no longer occurs, then confirm or abort this change.

@Clanker If author confirms results set frontmatter state to completed, otherwise to aborted. Update date, harness and model. If you have access to session info also add token count.
