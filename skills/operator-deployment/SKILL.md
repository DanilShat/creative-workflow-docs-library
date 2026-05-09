---
name: operator-deployment
description: Use when writing setup scripts, runbooks, env configuration, deployment checks, smoke tests, cleanup scripts, or operator-facing troubleshooting guides.
---

# Operator Deployment Skill

## Use when

Use this skill for:

- Windows setup scripts;
- server runbook;
- worker runbook;
- network/firewall notes;
- Ollama setup;
- Postgres setup;
- Playwright install;
- Adobe bridge setup;
- smoke tests;
- cleanup/retention commands.

## Operator-first rule

A human should be able to follow the runbook without guessing hidden steps.

Every command must state:

- where to run it;
- server or worker machine;
- required working directory;
- expected output;
- what to do if it fails.

## Required setup scripts

- `scripts/setup_server_windows.ps1`
- `scripts/setup_worker_windows.ps1`
- `scripts/check_server_health.ps1`
- `scripts/check_worker_health.ps1`
- `scripts/cleanup_artifacts.ps1` or Python equivalent.

## Network default

- LAN or private mesh VPN.
- FastAPI/UI exposed only to trusted network.
- Ollama remains localhost-only.
- Worker uses `WORKER_TOKEN`.

## Smoke test order

1. server health;
2. database migration status;
3. Ollama/local LLM health;
4. worker registration;
5. heartbeat;
6. job claim test;
7. artifact upload test;
8. browser profile status;
9. first live Gemini/Freepik path.

## Source inspiration

Adapted from production implementation/release gate patterns in `addyosmani/agent-skills` and from the project-specific worker runtime specs.
