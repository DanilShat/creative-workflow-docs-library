# План імплементації для Codex

## Мета

Цей документ пояснює, **в якому порядку треба збирати систему**, щоб у фіналі вийшов не демо-проєкт із моками, а реальна MVP-система, яку можна розгорнути на двох ноутбуках і прогнати end-to-end.

## Принцип роботи

Codex має працювати як **інженер, який доводить систему до робочого стану**, а не як генератор окремих файлів. Кожен етап повинен завершуватися:
- кодом;
- міграціями;
- конфігами;
- мінімально потрібними тестами;
- інструкцією, як перевірити етап локально;
- коротким списком того, що ще не готово.

## Порядок етапів

### Етап 1. Каркас репозиторію
Потрібно створити:
- `server/`
- `worker/`
- `shared/`
- `photoshop_plugin/`
- `aftereffects_bridge/`
- `scripts/`
- `tests/`
- `docs_runtime/`

На цьому етапі Codex повинен:
- зібрати Python workspace;
- налаштувати залежності;
- підготувати `.env.example`;
- додати базовий README;
- налаштувати lint, format, test commands.

### Етап 2. Shared contracts
Потрібно реалізувати:
- Pydantic-моделі для job schema;
- worker registration schema;
- heartbeat schema;
- artifact schema;
- error schema;
- enums для status/state transitions.

Цей шар повинен бути **єдиним джерелом правди** для сервера і воркера.

### Етап 3. Server core
Потрібно реалізувати:
- FastAPI app;
- local config loader;
- PostgreSQL integration;
- SQLAlchemy models + Alembic migrations;
- job queue tables;
- worker tables;
- artifact metadata tables;
- базовий REST API.

### Етап 4. Worker core
Потрібно реалізувати:
- worker service;
- registration;
- heartbeat;
- polling `claim-next-job`;
- job execution loop;
- upload artifacts back to server;
- structured logs.

### Етап 5. Local LLM orchestrator
Потрібно реалізувати:
- local model client;
- orchestration prompts;
- structured JSON outputs;
- fallback path, якщо local model не впоралась;
- routing до browser skills.

### Етап 6. Browser runtime
Потрібно реалізувати:
- Playwright runtime;
- profiles;
- traces;
- screenshots;
- downloads;
- popup handling;
- reusable flow runner.

### Етап 7. First real browser flows
Потрібно довести до робочого стану:
- `gemini_build_prompt_from_brief_and_refs`
- `gemini_repair_prompt_from_output_and_feedback`
- `freepik_generate_image_from_prompt`
- `freepik_download_selected_output`

Це перший справжній vertical slice.

### Етап 8. LangGraph workflows
Потрібно реалізувати:
- main graph;
- static subgraph;
- state persistence;
- review transitions;
- repair loop;
- export package step.

### Етап 9. Streamlit UI
Потрібно реалізувати:
- task intake;
- refs upload;
- progress view;
- outputs view;
- review controls;
- history view;
- error state rendering.

### Етап 10. Photoshop companion
Потрібно реалізувати:
- side panel;
- local bridge call;
- allowlisted host actions;
- preview + confirm execution;
- logs/status return.

### Етап 11. After Effects bridge
Потрібно реалізувати:
- local bridge runner;
- allowlisted actions;
- result payload;
- failure handling.

### Етап 12. E2E hardening
Потрібно реалізувати:
- cleanup jobs;
- retention policy;
- retry policy;
- timeout policy;
- acceptance suite;
- install scripts;
- deploy checklist.

## Що не можна робити

Codex не повинен:
- підміняти реальні інтеграції моками без явного маркування;
- залишати `TODO: implement later` у критичних шляхах;
- робити “заглушку”, яка просто повертає fake success;
- писати “цей крок завершений”, якщо немає способу реально його перевірити.

## Який результат вважати правильним

Правильний результат — це коли:
- сервер піднімається;
- воркер реєструється;
- task створюється;
- browser flow реально проходить;
- артефакт реально завантажується;
- статуси реально оновлюються;
- дизайнер бачить результат у UI.
