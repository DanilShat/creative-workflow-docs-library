# Start here — оновлений порядок роботи

## Найважливіше
Перед реалізацією спочатку запусти **reviewer-first chat** у Codex.

1. Відкрий цю папку як проект у Codex.
2. Прочитай `prompts/README_ua.md`.
3. Першим промптом у новому чаті дай:
   - `prompts/00_reviewer_first_system_review.md`
4. Якщо Codex знаходить critical blockers, дай:
   - `prompts/00_reviewer_gap_closure_patch_request.md`
5. Лише після цього переходь до implementation prompts.

Це потрібно, щоб Codex не почав одразу писати код по суперечливих або неповних спеках.

---

# Creative Workflow Docs Library — Start Here

Це робоча бібліотека документів для збірки **реального MVP**, а не демо.

## Path rule
If this folder is opened directly in Codex, paths in prompts/specs are relative to this folder. If the parent workspace is opened instead, all prompt/spec paths are relative to `creative_workflow_docs_library/`.

## Як орієнтуватися

- `human_ua/` — людські документи українською, щоб зрозуміти продукт, архітектуру, межі та rollout.
- `codex/` — детальні технічні спеки для реалізації.
- `skills/` — окремо винесені скіли у форматі папка + `SKILL.md`; тепер вони перезібрані на основі сильних GitHub/open-source джерел і мають source map.
- `prompts/` — готові промпти для роботи з Codex в **одному чаті**, плюс README з поясненням коли який промпт запускати, що очікувати на виході і як перевіряти результат.

## Найкращий шлях роботи

1. Спочатку прочитай `prompts/README_ua.md`.
2. Потім відкрий папку репозиторію в Codex.
3. Далі запускай промпти з `prompts/` у вказаному там порядку.
4. Після кожного етапу перевіряй результати по чеклисту з README.

## Якщо хочеш швидкий старт

- Для себе: `human_ua/00_INDEX_ua.md`, `human_ua/15_server_worker_architecture_ua.md`, `human_ua/16_local_llm_orchestrator_ua.md`, `human_ua/22_plan_rozgortannya_ta_perevirky_ua.md`
- Для Codex: `codex/00_README_FOR_CODEX.md`, `codex/31_implementation_master_plan.md`, `codex/32_codex_execution_rules_and_skills.md`, `codex/36_codex_master_prompt.md`
- Для скілів: `skills/README_ua.md`, `skills/00_SKILLS_INDEX.md`, `skills/GITHUB_SKILLS_SOURCE_MAP.md`
- Для запуску промптів: `prompts/README_ua.md`


## Остання ревізія

Додано `SPEC_REVIEW_2026_05_04.md` та `codex/37_spec_review_and_gap_fixes.md`. Вони фіксують реальні прогалини: network/auth між ноутами, browser profile setup, external skills policy, перший вертикальний slice, manual live browser tests і retention.

## v10 patch: актуальні файли перед реалізацією

Після reviewer-first звіту прочитай:
- `REVIEWER_PATCH_APPLIED_2026_05_04.md`
- `codex/39_reviewer_blocker_fixes_applied.md`
- `codex/40_claude_delegate_mcp_integration.md`
- `runtime_docs/first_vertical_slice.md`
- `runtime_docs/env.example.md`

Поточне правило: перший MVP gate = Gemini + Freepik browser E2E. Photoshop/AE та Claude йдуть після Gate A, якщо оператор явно не попросить інакше.
