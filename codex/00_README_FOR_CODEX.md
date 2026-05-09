# CURRENT TOPOLOGY WARNING

This older file is superseded where it conflicts with:
- `codex/21_server_worker_architecture.md`
- `codex/39_reviewer_blocker_fixes_applied.md`
- `codex/30_server_worker_acceptance_suite.md`

Current topology: server/control plane runs on operator laptop; worker/execution plane runs on designer laptop. First MVP gate is Gemini + Freepik browser E2E. DCC comes after Gate A.

---

# Codex Implementation Library

This package contains implementation-oriented specs for a **local, browser-first creative workflow system**.

## Key constraint
The agency does **not** have API-based access wired into their workflow. They work through consumer/web interfaces and subscriptions. Therefore the system must be designed **browser-first**, with future support for API adapters without changing core orchestration.

## Project intent
Build a local Python application that:
- runs as a two-machine MVP: server/control plane on the operator laptop and worker/execution plane on the designer laptop;
- uses Streamlit for the operator-hosted MVP UI;
- uses FastAPI for backend APIs and worker protocol;
- uses LangGraph for orchestration on the server;
- uses PostgreSQL for metadata;
- uses server-side filesystem storage for final assets;
- automates vendor web flows using Playwright on the designer worker;
- supports static image workflows first, then scene-based video workflows.


## Additional specs added later
- `13_dcc_integration_spec.md` — host app integration strategy for Photoshop / After Effects / CapCut
- `14_photoshop_uxp_plugin_spec.md` — Photoshop UXP plugin panel and bridge spec
- `15_after_effects_integration_spec.md` — After Effects scripting / CEP bridge spec
- `16_capcut_constraints_and_fallbacks.md` — CapCut constraints and fallback design

- 21_server_worker_architecture.md — final two-machine deployment model.
- 22_local_llm_orchestrator_spec.md — local LLM scope, fallback policy, model role.
- 23_worker_protocol_spec.md — worker registration, heartbeat, claim/complete protocol, file transfer.
- 24_deployment_and_network_spec.md — deployment topology, services, ports, env vars, ops rules.
- 25_api_and_ws_surface.md — concrete HTTP and WebSocket contracts between UI, server, and worker.

- 31_implementation_master_plan.md — exact milestone order for building a real MVP.
- 32_codex_execution_rules_and_skills.md — implementation behavior, skills, and quality bar for Codex.
- 33_code_style_and_commenting_contract.md — required commenting style and code readability rules.
- 34_test_strategy_and_quality_bar.md — what to test, what not to test, and merge bar.
- 35_operator_deployment_runbook.md — deployment and operator checklist for the owner.
- 36_codex_master_prompt.md — compact master prompt for Codex execution.
