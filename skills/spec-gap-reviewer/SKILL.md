---
name: spec-gap-reviewer
description: Use to inspect a specification library for contradictions, outdated overrides, missing implementation details, and unclear acceptance criteria before coding begins. Outputs a gap register and concrete doc patch list.
---

# Spec Gap Reviewer Skill

## Purpose
Use this skill before implementation to check that the docs are internally consistent and operationally complete.

This is a spec-level review, not a code review.

## What to detect

### Contradictions
- API-first language that conflicts with browser-first architecture.
- Local-only language that conflicts with server/worker two-machine architecture.
- Photoshop/AE arbitrary script execution language that conflicts with allowlisted action protocol.
- Mock/demo wording that conflicts with real MVP requirement.

### Missing operational details
- Install order.
- Environment variables.
- Worker pairing/auth.
- Browser profile setup.
- Postgres migration steps.
- File storage layout.
- First-run smoke tests.

### Missing contracts
- Job schema.
- Artifact upload contract.
- Host action request/response contract.
- Browser flow result contract.
- Failure classification.
- Retry/lease policy.

### Weak acceptance criteria
- Criteria that only say “component exists”.
- Criteria that can pass with mocks only.
- Criteria that do not prove the first end-to-end path.

## Required output

```markdown
# Spec Gap Register

## Must fix before Codex implementation
| ID | File(s) | Problem | Why it blocks | Patch instruction |

## Should fix before implementation
| ID | File(s) | Problem | Risk | Patch instruction |

## Good enough for MVP
List areas that are intentionally simple and should not be overengineered.

## Contradiction map
| Old wording / assumption | Correct current decision | Files to update or override |

## Acceptance upgrade list
List acceptance criteria that must be converted from vague to executable.
```

## Rules
- Do not invent a bigger product.
- Do not ask for perfect specs.
- Focus on gaps that could make Codex build the wrong thing or build a fake demo.
- Prefer explicit assumptions over new clarification questions.
