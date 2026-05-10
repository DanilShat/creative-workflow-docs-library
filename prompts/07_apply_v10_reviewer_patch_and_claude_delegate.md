Read the v10 patch files before any implementation work:

- archive/reviews/REVIEWER_PATCH_APPLIED_2026_05_04.md
- codex/39_reviewer_blocker_fixes_applied.md
- codex/40_claude_delegate_mcp_integration.md
- runtime_docs/env.example.md
- runtime_docs/first_vertical_slice.md
- codex/30_server_worker_acceptance_suite.md
- codex/25_api_and_ws_surface.md
- codex/23_worker_protocol_spec.md
- codex/27_job_schema_and_state_machine.md
- codex/07_browser_automation_spec.md
- codex/28_file_transfer_and_artifact_protocol.md
- codex/35_operator_deployment_runbook.md

Then produce a readiness brief:
1. Confirm the current first MVP gate.
2. Confirm that Photoshop/AE are post-Gate-A.
3. Confirm that Claude is optional delegated orchestrator via MCP, not core dependency.
4. List exact components needed for Gate A.
5. List any remaining blockers before implementation.

Do not write code in this prompt.
