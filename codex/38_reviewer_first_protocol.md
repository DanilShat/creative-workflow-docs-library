# Reviewer-First Protocol

## Why this exists
Before Codex writes code, run a dedicated review chat. The reviewer should evaluate the documentation library as a whole system and identify only the gaps that could cause a wrong or fake implementation.

This stage exists to prevent a common failure mode: Codex reads many specs, resolves contradictions incorrectly, then builds a beautiful scaffold that is not a working MVP.

## Reviewer role
The reviewer acts as:
- system architect,
- spec gap analyst,
- production MVP validator,
- risk reviewer,
- implementation gatekeeper.

The reviewer must not write implementation code.

## Reviewer skills to load
- `skills/system-architecture-reviewer/SKILL.md`
- `skills/spec-gap-reviewer/SKILL.md`
- `skills/implementation-review-gate/SKILL.md`
- `skills/production-engineering/SKILL.md`
- `skills/testing-quality-gates/SKILL.md`
- `skills/server-worker-runtime/SKILL.md`
- `skills/playwright-browser-automation/SKILL.md`

## First reviewer task
Use `prompts/00_reviewer_first_system_review.md`.

Expected output:
- build readiness verdict,
- critical blockers,
- important gaps,
- contradiction map,
- first vertical slice validation,
- exact spec patch plan.

## Second reviewer task
If the reviewer finds gaps, use `prompts/00_reviewer_gap_closure_patch_request.md`.

Expected output:
- exact patch instructions for docs,
- implementation assumptions,
- acceptance criteria upgrades,
- final readiness checklist.

## What counts as a real blocker
A finding is a blocker only if it could cause:
- wrong machine ownership,
- fake/mock-only implementation,
- missing job lifecycle,
- unsafe host scripting,
- untestable E2E path,
- impossible first-run deployment,
- unclear browser profile/auth setup,
- data loss or uncontrollable file growth.

## What is not a blocker
Not a blocker for MVP:
- no polished UI,
- no cloud deployment,
- no multi-user tenant model,
- no full AE automation,
- no CapCut integration,
- no ML-based smart routing,
- no fully automated live-site tests for paid services.

## Current canonical decisions
The reviewer must treat these as current truth:

1. Server runs on operator laptop.
2. Worker runs on designer laptop.
3. Local LLM runs only as the orchestrator brain on the operator laptop.
4. Browser-based services are executed from the designer laptop through Playwright workers.
5. Photoshop/After Effects integration uses allowlisted typed host actions only.
6. PostgreSQL stores metadata; binary assets live on disk.
7. MVP transport is HTTP polling plus heartbeat; WebSocket is optional later.
8. First vertical slice must be real, not mocked.
