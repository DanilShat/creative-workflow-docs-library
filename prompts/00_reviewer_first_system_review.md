# Prompt 00 — Reviewer-first system review

Use this prompt as the first message in a new Codex chat before implementation.

---

You are not implementing code yet.

Act as a senior system architecture reviewer and spec gap reviewer for this repository.

First load and use these skills:
- skills/system-architecture-reviewer/SKILL.md
- skills/spec-gap-reviewer/SKILL.md
- skills/implementation-review-gate/SKILL.md
- skills/production-engineering/SKILL.md
- skills/testing-quality-gates/SKILL.md
- skills/server-worker-runtime/SKILL.md
- skills/playwright-browser-automation/SKILL.md

Then read the documentation library in this order:

1. README_START_HERE.md
2. SPEC_REVIEW_2026_05_04.md
3. codex/37_spec_review_and_gap_fixes.md
4. codex/38_reviewer_first_protocol.md
5. REVIEWER_PATCH_APPLIED_2026_05_04.md
6. codex/39_reviewer_blocker_fixes_applied.md
7. codex/40_claude_delegate_mcp_integration.md
8. runtime_docs/first_vertical_slice.md
9. runtime_docs/env.example.md
10. codex/21_server_worker_architecture.md
11. codex/22_local_llm_orchestrator_spec.md
12. codex/23_worker_protocol_spec.md
13. codex/24_deployment_and_network_spec.md
14. codex/25_api_and_ws_surface.md
15. codex/26_worker_service_design.md
16. codex/27_job_schema_and_state_machine.md
17. codex/28_file_transfer_and_artifact_protocol.md
18. codex/29_reliability_and_failure_policy.md
19. codex/30_server_worker_acceptance_suite.md
20. codex/07_browser_automation_spec.md
21. codex/13_dcc_integration_spec.md
22. codex/17_host_action_protocol.md
23. codex/18_photoshop_panel_companion_spec.md
24. codex/19_after_effects_bridge_companion_spec.md
25. codex/31_implementation_master_plan.md
26. codex/32_codex_execution_rules_and_skills.md
27. codex/33_code_style_and_commenting_contract.md
28. codex/34_test_strategy_and_quality_bar.md
29. codex/35_operator_deployment_runbook.md
30. prompts/README_ua.md
31. skills/GITHUB_SKILLS_SOURCE_MAP.md

Do not write code.
Do not create files yet.
Do not expand scope.

Your task:
Review the specs as a complete real MVP system.
Find only real gaps, contradictions, blockers, and missing implementation details that could make Codex build the wrong thing or build a fake/mock-only demo.

Current canonical decisions:
- Server/control plane runs on the operator laptop.
- Worker/execution plane runs on the designer laptop.
- Local LLM is used only for orchestration on the operator laptop.
- Browser-based services run through Playwright on the designer laptop.
- Photoshop and After Effects use typed allowlisted host actions only.
- PostgreSQL stores metadata; media assets live on disk.
- MVP transport is HTTP polling with heartbeat.
- First vertical slice must be real end-to-end, not mock-only.
- Gate A MVP UI default is Streamlit hosted on the operator laptop.
- Canonical initial worker id is `designer-laptop-01`.

Return this exact structure:

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

## Contradiction map
| Old wording or assumption | Correct current decision | Files to update or override |

## First vertical slice validation
Describe the first real MVP path from user request to artifact upload and review. List every component that must exist for it to run.

## Architecture decisions that should stay unchanged
List sound decisions that should not be revisited unless new evidence appears.

## Spec patch plan
List exact files that should be changed, created, or clarified before implementation.

## Reviewer questions for the operator
Ask only questions that truly block implementation. Prefer assumptions for non-blocking details.
