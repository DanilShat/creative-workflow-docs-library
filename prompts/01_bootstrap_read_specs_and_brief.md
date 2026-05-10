Open and read these materials before coding:

- README_START_HERE.md
- archive/reviews/REVIEWER_PATCH_APPLIED_2026_05_04.md
- skills/README_ua.md
- all files in skills/
- codex/39_reviewer_blocker_fixes_applied.md
- codex/40_claude_delegate_mcp_integration.md
- runtime_docs/first_vertical_slice.md
- runtime_docs/env.example.md
- codex/00_README_FOR_CODEX.md
- codex/31_implementation_master_plan.md
- codex/32_codex_execution_rules_and_skills.md
- codex/33_code_style_and_commenting_contract.md
- codex/34_test_strategy_and_quality_bar.md
- codex/21_server_worker_architecture.md
- codex/22_local_llm_orchestrator_spec.md
- codex/23_worker_protocol_spec.md
- codex/24_deployment_and_network_spec.md
- codex/25_api_and_ws_surface.md
- codex/26_worker_service_design.md
- codex/27_job_schema_and_state_machine.md
- codex/28_file_transfer_and_artifact_protocol.md
- codex/29_reliability_and_failure_policy.md
- codex/30_server_worker_acceptance_suite.md
- codex/07_browser_automation_spec.md
- codex/13_dcc_integration_spec.md
- codex/14_photoshop_uxp_plugin_spec.md
- codex/15_after_effects_integration_spec.md
- codex/17_host_action_protocol.md
- codex/18_photoshop_panel_companion_spec.md
- codex/19_after_effects_bridge_companion_spec.md
- codex/20_agent_skills_and_tool_routing_spec.md
- codex/35_operator_deployment_runbook.md
- codex/36_codex_master_prompt.md

Do not write code yet.

First produce a concise but concrete implementation brief with:
1. your understanding of the full system,
2. the exact final repository structure you will create,
3. the execution order you will follow,
4. the real MVP components you will implement,
5. the runtime boundaries between server and worker,
6. the role of the local LLM,
7. confirmation that Gate A uses Streamlit on the operator laptop and `designer-laptop-01` as the initial worker id,
8. any blocking contradictions or missing assumptions.

Rules:
- This must become a real working MVP, not a demo and not mock-heavy scaffolding.
- Prefer sensible engineering decisions over unnecessary questions.
- Do not postpone critical paths.
- Comments in code must explain functional components clearly because the operator wants to learn from the code.
- Tests must validate behavior and contracts, not mirror implementation internals.

After the implementation brief, wait for the next instruction.
