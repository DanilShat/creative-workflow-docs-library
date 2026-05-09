---
name: implementation-review-gate
description: Use after Codex produces an implementation plan or code to verify that it matches the specs and is not a mock-only or placeholder implementation. Blocks progression until critical issues are fixed.
---

# Implementation Review Gate Skill

## Purpose
Use this after Codex returns an implementation brief, a first build, or a hardening pass.

This skill checks whether the implementation is real enough to proceed.

## Gate levels

### Gate 0: Before coding
Validate that Codex understood the system and proposed a correct repo structure and execution order.

### Gate 1: After first implementation
Validate that core components exist and can run:
- server app
- worker app
- shared contracts
- database models/migrations
- storage layer
- job lifecycle
- artifact protocol
- browser runtime abstraction
- at least one real browser flow path scaffolded for live execution
- tests and runbook

### Gate 2: After hardening
Validate that placeholders, TODOs, fake implementations, inconsistent commands, and weak tests are removed or explicitly documented as out of scope.

## Red flags
- `pass`, `TODO`, `NotImplementedError`, `mock`, `fake`, `placeholder`, `stub` in production paths.
- Tests that assert only object construction.
- Browser flows that never launch Playwright.
- Worker protocol with no real heartbeat/polling/status path.
- Database models with no migration path.
- Docs that mention commands that do not exist.
- Adobe integration that executes arbitrary generated code by default.

## Output format

```markdown
# Implementation Gate Report

## Gate verdict
Pass / Conditional pass / Fail

## Blocking findings
| ID | Finding | Evidence | Required fix |

## Important findings
| ID | Finding | Evidence | Suggested fix |

## Real-MVP proof checklist
- [ ] server starts
- [ ] worker starts
- [ ] worker registers
- [ ] heartbeat works
- [ ] job is claimed
- [ ] job status changes
- [ ] artifact is uploaded
- [ ] task history is visible
- [ ] tests cover contracts and state transitions
- [ ] runbook matches actual commands

## Next allowed action
State whether the operator should proceed, ask Codex to patch, or stop and clarify.
```

## Rules
- Be strict about fake implementations.
- Do not block on non-MVP polish.
- Do not demand full live browser credentials in automated tests; live browser tests can be manual/marked.
- Treat missing deployment/run commands as a serious issue.
