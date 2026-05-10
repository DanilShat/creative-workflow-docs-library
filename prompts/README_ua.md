# Reviewer-first етап — запускати ПЕРЕД реалізацією

Перед тим як давати Codex промпт `02_build_real_mvp.md`, спочатку запусти окремий reviewer-chat.

## 0A. `00_reviewer_first_system_review.md`

**Коли запускати:** першим повідомленням у новому чаті Codex, до будь-якого коду.

**Для чого:** щоб Codex виступив не виконавцем, а архітектурним рев'юером: перевірив всю бібліотеку спек, знайшов справжні блокери, суперечності й дірки в acceptance criteria.

**Що очікувати:** звіт `System Review Report` з verdict, blockers, gaps, contradiction map, first vertical slice і patch plan.

**Що робити тобі:** якщо є `Critical blockers`, не переходь до реалізації. Запускай 0B.

## 0B. `00_reviewer_gap_closure_patch_request.md`

**Коли запускати:** після 0A, якщо reviewer знайшов blocker/gap.

**Для чого:** перетворити рев'ю у конкретні правки документації або чіткі implementation assumptions.

**Що очікувати:** `Gap Closure Patch Plan` з точними файлами, секціями, acceptance checks і ready-to-build verdict.

**Що робити тобі:** після цього або просиш Codex внести патчі в документацію, або якщо всі gaps прийняті як assumptions — переходиш до основних промптів реалізації.

# Папка prompts — як працювати з Codex в одному чаті

Тут лежать готові промпти для роботи з Codex **в одному чаті**. Вони розбиті по етапах, щоб Codex не захлинувся відразу у всій роботі і не почав халтурити.

## Загальний принцип

Ти відкриваєш папку проєкту в Codex і працюєш по черзі:
1. prompt 01 — Codex читає спеки і збирає implementation brief
2. prompt 02 — Codex реалізує весь MVP
3. prompt 03 — Codex робить hardening pass
4. prompt 04 — Codex звіряє runbook, запуск і smoke tests
5. optional prompt 05 — якщо треба добити окремі прогалини
6. optional prompt 06 — якщо треба звірити спеки з новими GitHub-researched skills і gap review

## Що очікувати від кожного етапу

### 01_bootstrap_read_specs_and_brief.md
**Для чого:** змусити Codex спочатку прочитати спеки й описати, як він зрозумів систему.

**Що чекати:**
- короткий, але точний implementation brief
- фінальну repo structure
- execution order
- список реальних компонентів MVP
- список суперечностей або блокерів, якщо вони є

**Що перевірити:**
- чи правильно зрозумів server/worker архітектуру
- чи не намагається перенести браузери/Photoshop/AE на сервер
- чи local LLM лишив тільки для orchestration
- чи розуміє, що продукт має бути робочим, а не демонстраційним

### 02_build_real_mvp.md
**Для чого:** основна реалізація.

**Що чекати:**
- код по всьому репозиторію
- migrations
- server
- worker
- contracts
- browser layer
- storage
- tests
- run scripts

**Що перевірити:**
- немає критичних stub/pass/TODO
- є реальний worker lifecycle
- є artifact upload/download
- є хоча б один реальний browser flow path
- є локальний orchestrator LLM client path

### 03_hardening_pass.md
**Для чого:** вибити з репозиторію всі напівготові місця.

**Що чекати:**
- cleanup неповних місць
- посилення тестів
- синхронізацію runbook із кодом
- виправлення inconsistent env vars / scripts / paths

**Що перевірити:**
- зникли слабкі місця
- немає фальшивих тестів
- коментарі справді пояснюють функціональні компоненти

### 04_runbook_and_smoke_validation.md
**Для чого:** змусити Codex пройтися по реальному запуску проекту як оператор.

**Що чекати:**
- чіткий порядок запуску
- exact commands
- first-run steps
- smoke test order
- manual verification checklist

**Що перевірити:**
- можна реально повторити кроки руками
- не бракує setup-інструкцій
- paths, ports, env vars не суперечать коду

### 05_targeted_gap_closure.md
**Для чого:** добити конкретні прогалини, якщо після запуску щось не зійшлося.

**Коли використовувати:**
- якщо знайшовся конкретний missing path
- якщо runbook не збігається з кодом
- якщо worker lifecycle десь неповний
- якщо тести слабкі

## Робочий порядок

1. Відкрив репозиторій у Codex.
2. Скопіював prompt 01.
3. Перевірив implementation brief.
4. Скопіював prompt 02.
5. Дочекався великої реалізації.
6. Проглянув репозиторій на критичні дірки.
7. Скопіював prompt 03.
8. Скопіював prompt 04.
9. Лише після цього руками запускаєш систему.

## Чого не робити

- Не давати відразу один гігантський промпт з усім на світі.
- Не дробити на 30 дрібних завдань до того, як зібраний каркас.
- Не погоджуватися на “додамо пізніше”, якщо це критична частина MVP.

## Які файли нехай Codex обов'язково прочитає

Перш ніж запускати prompt 01, попроси його прочитати:
- `README_START_HERE.md`
- `archive/reviews/REVIEWER_PATCH_APPLIED_2026_05_04.md`
- `skills/README_ua.md`
- усі файли з `skills/`
- `codex/39_reviewer_blocker_fixes_applied.md`
- `codex/40_claude_delegate_mcp_integration.md`
- `runtime_docs/first_vertical_slice.md`
- `runtime_docs/env.example.md`
- `codex/00_README_FOR_CODEX.md`
- `codex/31_implementation_master_plan.md`
- `codex/32_codex_execution_rules_and_skills.md`
- `codex/33_code_style_and_commenting_contract.md`
- `codex/34_test_strategy_and_quality_bar.md`
- `codex/21_server_worker_architecture.md`
- `codex/22_local_llm_orchestrator_spec.md`
- `codex/23_worker_protocol_spec.md`
- `codex/26_worker_service_design.md`
- `codex/27_job_schema_and_state_machine.md`
- `codex/28_file_transfer_and_artifact_protocol.md`
- `codex/29_reliability_and_failure_policy.md`
- `codex/30_server_worker_acceptance_suite.md`
- `codex/07_browser_automation_spec.md`
- `codex/13_dcc_integration_spec.md`
- `codex/14_photoshop_uxp_plugin_spec.md`
- `codex/15_after_effects_integration_spec.md`
- `codex/17_host_action_protocol.md`
- `codex/18_photoshop_panel_companion_spec.md`
- `codex/19_after_effects_bridge_companion_spec.md`
- `codex/20_agent_skills_and_tool_routing_spec.md`
- `codex/35_operator_deployment_runbook.md`
- `codex/36_codex_master_prompt.md`


### 06_review_specs_and_github_skills.md
**Для чого:** змусити Codex перечитати нову ревізію спек і skills, перезібрані на основі GitHub/open-source джерел.

**Коли використовувати:** перед стартом коду або перед hardening pass, якщо хочеш, щоб Codex не пропустив network/auth, browser profile setup, first E2E vertical slice і external skills safety.

**Що чекати:** короткий gap list, список файлів для зміни, порядок імплементації і verification checklist.

## Оновлення v10: reviewer patch + Claude delegate

Після `00_reviewer_first_system_review.md` Codex має прочитати:
- `codex/39_reviewer_blocker_fixes_applied.md`
- `codex/40_claude_delegate_mcp_integration.md`
- `runtime_docs/first_vertical_slice.md`
- `runtime_docs/env.example.md`

Перший build prompt тепер означає Gate A: Gemini + Freepik browser E2E. Photoshop/AE і Claude — наступні gates, якщо ти явно не попросиш включити їх у перший build.
