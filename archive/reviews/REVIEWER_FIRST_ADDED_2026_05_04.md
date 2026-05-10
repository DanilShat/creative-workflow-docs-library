# Reviewer-first layer added

This version adds a dedicated review stage before implementation.

## Why
The documentation library is now large enough that Codex should not start coding immediately. It should first act as a reviewer and validate that the system is internally consistent and buildable as a real MVP.

## Added files

### Skills
- `skills/system-architecture-reviewer/SKILL.md`
- `skills/spec-gap-reviewer/SKILL.md`
- `skills/implementation-review-gate/SKILL.md`

### Prompts
- `prompts/00_reviewer_first_system_review.md`
- `prompts/00_reviewer_gap_closure_patch_request.md`

### Specs / human docs
- `codex/38_reviewer_first_protocol.md`
- `human_ua/25_reviewer_first_workflow_ua.md`

## New workflow
1. Run reviewer prompt 00 in a new Codex chat.
2. Read the system review report.
3. If blockers exist, run prompt 00B.
4. Patch docs or accept explicit assumptions.
5. Only then run implementation prompts.

## Reviewer constraints
The reviewer must not implement code. It must identify blockers, contradictions, and missing details that would make a real MVP fail.
