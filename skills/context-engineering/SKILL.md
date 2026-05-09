---
name: context-engineering
description: Use when designing prompts, orchestration state, LLM input/output schemas, long-running agent sessions, or Codex implementation sessions with many specs.
---

# Context Engineering Skill

## Use when

Use this skill for:

- local LLM orchestration prompts;
- LangGraph state design;
- structured JSON outputs;
- prompt repair loops;
- Codex long-session planning;
- deciding what context goes to server, worker, browser flows or DCC bridges.

## Goal

Keep the agent focused on the smallest high-signal context needed for the current decision.

## Rules for local orchestrator LLM

The local LLM should receive:

- task summary;
- current state;
- relevant constraints;
- available skills/tools;
- expected JSON schema.

It should not receive:

- full unrelated prompt history;
- large binary/media contents;
- raw browser traces unless diagnosing;
- every previous artifact when a compact summary is enough.

## Structured outputs

Every orchestration decision should be parseable:

- route decision;
- missing fields;
- next action;
- confidence;
- reason;
- required worker capability.

If JSON parsing fails, retry once with a repair instruction. If still invalid, escalate to deterministic fallback or human review.

## Context compression policy

For long tasks:

1. keep canonical task state in DB;
2. summarize old chat/review notes;
3. keep prompts/version history by reference IDs;
4. load full detail only for the current run or repair decision.

## Tool design policy

A tool/skill should have:

- narrow input schema;
- narrow output schema;
- explicit failure classes;
- no hidden side effects outside its responsibility.

## Source inspiration

Adapted for this project from context-engineering patterns in `muratcankoylan/Agent-Skills-for-Context-Engineering` and the Agent Skills progressive-disclosure model.
