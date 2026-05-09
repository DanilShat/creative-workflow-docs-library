# Бібліотека документації: Local Creative Workflow Orchestrator

## Призначення

Це бібліотека документації для системи, де:
- сервер і оркестратор працюють на ноутбуці власника;
- воркер, браузери, Photoshop і After Effects працюють на ноутбуці дизайнера;
- локальна LLM використовується лише для orchestration, а не для генерації медіа;
- browser-first інтеграції залишаються головним способом роботи із зовнішніми сервісами.

## Структура

### Human docs (українською)
- `01_product_overview_ua.md`
- `02_scope_and_non_goals_ua.md`
- `03_architecture_ua.md`
- `04_workflows_ua.md`
- `05_frontend_streamlit_ua.md`
- `06_data_and_storage_ua.md`
- `07_browser_automation_ua.md`
- `08_observability_and_eval_ua.md`
- `09_mvp_plan_ua.md`
- `10_open_questions_ua.md`
- `11_glossary_ua.md`
- `12_dcc_integrations_ua.md`
- `13_photoshop_aftereffects_companion_ua.md`
- `14_host_actions_and_skills_catalog_ua.md`
- `15_server_worker_architecture_ua.md`
- `16_local_llm_orchestrator_ua.md`
- `17_worker_protocols_ua.md`
- `18_deployment_and_ops_ua.md`
- `19_worker_service_design_ua.md`
- `20_reliability_and_real_mvp_ua.md`
- `21_plan_implementacii_dlya_codex_ua.md`
- `22_plan_rozgortannya_ta_perevirky_ua.md`
- `23_codex_skill_profile_ua.md`

### Codex docs
- `00_README_FOR_CODEX.md`
- `01_system_spec.md`
- `02_project_structure.md`
- `03_domain_model.md`
- `04_database_schema.md`
- `05_langgraph_workflow.md`
- `06_streamlit_ui_spec.md`
- `07_browser_automation_spec.md`
- `08_provider_adapter_contracts.md`
- `09_storage_retention_spec.md`
- `10_milestones.md`
- `11_acceptance_criteria.md`
- `12_open_questions.md`
- `13_dcc_integration_spec.md`
- `14_photoshop_uxp_plugin_spec.md`
- `15_after_effects_integration_spec.md`
- `16_capcut_constraints_and_fallbacks.md`
- `17_host_action_protocol.md`
- `18_photoshop_panel_companion_spec.md`
- `19_after_effects_bridge_companion_spec.md`
- `20_agent_skills_and_tool_routing_spec.md`
- `21_server_worker_architecture.md`
- `22_local_llm_orchestrator_spec.md`
- `23_worker_protocol_spec.md`
- `24_deployment_and_network_spec.md`
- `25_api_and_ws_surface.md`
- `26_worker_service_design.md`
- `27_job_schema_and_state_machine.md`
- `28_file_transfer_and_artifact_protocol.md`
- `29_reliability_and_failure_policy.md`
- `30_server_worker_acceptance_suite.md`

## Ключова фінальна позиція

Це **не демо-агент** і не набір моків. Це двомашинна MVP-система з реальною оркестрацією, реальними браузерними флоу і реальними host actions.

## Головні архітектурні рішення

- control plane на ноутбуці власника;
- execution plane на ноутбуці дизайнера;
- локальна LLM тільки для orchestration;
- worker працює через HTTP + polling;
- один активний job на воркері;
- артефакти йдуть окремо від JSON;
- browser flows і host actions тільки allowlisted.
