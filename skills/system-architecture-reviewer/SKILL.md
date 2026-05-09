---
name: system-architecture-reviewer
description: Use before implementation to review this project as a complete system: architecture, boundaries, deployment topology, data flow, integration risks, and evolution path. Do not write code with this skill; produce findings, risk ratings, and concrete spec patches.
---

# System Architecture Reviewer Skill

## Purpose
Use this skill when the operator asks for a first-pass review of the whole Creative Workflow Orchestrator before coding starts.

The reviewer must act like a senior architect reviewing a real MVP that must work end-to-end, not like a demo scaffold.

## Inputs to read first
Read, in this order:

1. `README_START_HERE.md`
2. `SPEC_REVIEW_2026_05_04.md`
3. `codex/37_spec_review_and_gap_fixes.md`
4. `codex/21_server_worker_architecture.md`
5. `codex/22_local_llm_orchestrator_spec.md`
6. `codex/23_worker_protocol_spec.md`
7. `codex/24_deployment_and_network_spec.md`
8. `codex/26_worker_service_design.md`
9. `codex/27_job_schema_and_state_machine.md`
10. `codex/28_file_transfer_and_artifact_protocol.md`
11. `codex/29_reliability_and_failure_policy.md`
12. `codex/30_server_worker_acceptance_suite.md`
13. `codex/07_browser_automation_spec.md`
14. `codex/13_dcc_integration_spec.md`
15. `codex/17_host_action_protocol.md`
16. `codex/18_photoshop_panel_companion_spec.md`
17. `codex/19_after_effects_bridge_companion_spec.md`
18. `codex/31_implementation_master_plan.md`
19. `codex/34_test_strategy_and_quality_bar.md`
20. all files in `skills/` that are relevant to the finding being evaluated.

## Review checklist
Evaluate the system across these dimensions:

### 1. End-to-end viability
- Is there one clear first vertical slice?
- Can the server, worker, browser flow, storage, and UI form a working path without mocks?
- Are manual setup steps explicit enough to execute?

### 2. Boundaries and ownership
- What runs on the operator laptop?
- What runs on the designer laptop?
- Which machine owns files, browser sessions, Adobe integrations, and credentials?
- Are cross-machine responsibilities unambiguous?

### 3. Protocol correctness
- Are worker registration, heartbeat, job polling, job claiming, status reporting, artifact upload, and failure reporting specified precisely enough?
- Are job leases and retries safe against duplicate execution?
- Are terminal states and retryable states clearly separated?

### 4. Integration realism
- Browser automation must be browser-first and live-site aware.
- Photoshop and After Effects must use allowlisted actions, not arbitrary generated host code.
- Gemini/Freepik/Kling/Flow/Higgsfield flows must have explicit setup and failure states.

### 5. Local LLM role
- Local LLM is only the orchestration brain.
- Browser Gemini and external tools are prompt/generation execution skills.
- No heavy local multimodal assumptions should be required for MVP.

### 6. Data and retention
- Postgres stores metadata only.
- Binary assets live on disk.
- Retention, dedupe, and artifact ownership must be specified.

### 7. Security and safety
- Ollama/local LLM must not be exposed directly to the network.
- Worker auth token or pairing token must exist.
- No arbitrary script execution in Photoshop/AE.
- Browser profile directories must be separate from the user’s main browser profile.

### 8. Testability
- Separate contract tests, integration tests, manual live-browser tests, and operator smoke tests.
- Do not call mocked-only flows “done”.
- The acceptance suite must prove a real MVP path.

## Output format
Produce exactly this structure:

```markdown
# System Review Report

## Executive verdict
- Build readiness: Ready / Almost ready / Not ready
- Main reason:

## Critical blockers
| ID | Blocker | Why it matters | Required spec fix | Owner | Verify by |

## Important gaps
| ID | Gap | Risk | Suggested fix | Affected files |

## Non-blocking improvements
| ID | Improvement | Why now or later | Suggested handling |

## First vertical slice validation
Describe the first end-to-end MVP path and list every component that must exist for it to run.

## Architecture decisions that should stay unchanged
List decisions that are sound and should not be revisited unless new evidence appears.

## Spec patch plan
List exact files that should be changed, created, or clarified before implementation.

## Reviewer questions for the operator
Ask only questions that truly block implementation. Prefer assumptions for non-blocking details.
```

## Rules
- Do not implement code.
- Do not rewrite the whole product.
- Do not suggest cloud/SaaS migration for MVP unless a current design is impossible.
- Do not expand scope beyond the stated MVP.
- Prefer concrete patches over vague advice.
- If something is good enough for MVP, say so and avoid overengineering.
