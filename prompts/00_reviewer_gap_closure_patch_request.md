# Prompt 00B — Close reviewer gaps before implementation

Use this prompt only after Prompt 00 returns a System Review Report.

---

Based on your System Review Report, perform a documentation patch planning pass.

Do not write production code.
Do not expand MVP scope.

Your job is to convert the review into concrete implementation-ready spec changes.

For every critical blocker or important gap, produce:
1. exact target file path,
2. exact section to add or modify,
3. precise replacement/addition text,
4. acceptance criteria that prove the gap is closed,
5. whether this patch must be done before code or can be left as an implementation assumption.

Return this exact structure:

# Gap Closure Patch Plan

## Must patch before implementation
| ID | File | Section | Patch summary | Acceptance check |

## Can proceed with assumption
| ID | Assumption | Where to document | Why acceptable for MVP |

## Updated first vertical slice
Write the final first E2E slice as a step-by-step implementation target.

## Updated implementation order
List the implementation order Codex should follow after patches are applied.

## Ready-to-build verdict
Ready / Not ready, with one paragraph explanation.
