---
name: testing-quality-gates
description: Use when writing tests, acceptance suites, smoke checks, or hardening passes. Ensures tests validate behavior and real contracts rather than repeating implementation details.
---

# Testing and Quality Gates Skill

## Use when

Use this skill for:

- unit tests;
- contract tests;
- worker lifecycle tests;
- state machine tests;
- file/artifact tests;
- browser flow smoke checks;
- hardening pass.

## Test tiers

### Unit tests
Cover pure logic:

- schema validation;
- routing policy;
- state transitions;
- retry decisions;
- retention selection.

### Contract tests
Cover interfaces:

- worker registration payload;
- heartbeat;
- claim-next;
- status update;
- artifact upload metadata;
- host action result shape.

### Local integration tests
Cover server-worker interaction against a real local server and test DB.

### Manual live tests
Cover browser sites that require accounts:

- Gemini login/profile status;
- Gemini prompt-builder run;
- Freepik image generation;
- Freepik download/upload.

Manual live tests must not be falsely represented as automated mock tests.

## Anti-patterns

Do not write tests that only:

- instantiate a class and assert it exists;
- mock every important behavior;
- assert implementation internals instead of observable results;
- pass when real runtime paths are broken.

## Done criteria

A feature is test-complete when:

- happy path is covered;
- important failure modes are covered;
- contracts are checked with representative payloads;
- tests fail if job state machine breaks;
- runbook includes manual checks for live browser flows.

## Source inspiration

Adapted from production engineering quality gates in `addyosmani/agent-skills` and Playwright testing patterns from `willcoliveira/qualiow-playwright-skills`.
