---
name: production-engineering
description: Use when implementing core application code, architecture, migrations, runtime paths, or major refactors. Focuses Codex on production-minded, verifiable implementation rather than demo scaffolding.
---

# Production Engineering Skill

## Use when

Use this skill when implementing or modifying:

- FastAPI server code;
- worker runtime code;
- database models/migrations;
- storage/artifact handling;
- orchestration logic;
- deployment scripts;
- large refactors.

## Primary rule

Build a working product path, not an architectural sketch.

A feature is not complete until:

1. code path exists;
2. configuration exists;
3. persistence/storage is wired;
4. error handling exists;
5. tests cover behavior;
6. runbook or command exists;
7. no critical `pass`, fake success, TODO-later or mock-only runtime path remains.

## Implementation workflow

1. Read the relevant spec files before coding.
2. Identify inputs, outputs, persistence, runtime owner and failure modes.
3. Implement shared contracts first.
4. Implement the real runtime path.
5. Add tests around behavior and contract boundaries.
6. Add comments where a future reader needs the mental model.
7. Update docs/runbook if commands, env vars or paths change.
8. Run local verification commands.

## Quality gates

Before claiming done, verify:

- the code can run from a clean checkout;
- env vars are documented;
- database migrations exist and apply;
- no runtime mocks are required for the happy path;
- failure states are represented explicitly;
- logs are actionable;
- tests fail when behavior breaks.

## Do

- Prefer small modules with explicit responsibilities.
- Keep interfaces typed and serializable.
- Make failure visible instead of silently swallowing it.
- Write comments that explain why a component exists, not line-by-line noise.
- Preserve the server/worker boundary.

## Do not

- Implement a fake worker that only prints success.
- Hide unfinished parts behind `NotImplementedError` in runtime code.
- Store large binary assets in PostgreSQL.
- Let worker call the local LLM directly.
- Execute unreviewed third-party scripts.

## Source inspiration

Adapted for this project from production-grade engineering skill patterns in `addyosmani/agent-skills` and from the Agent Skills progressive-disclosure format.
