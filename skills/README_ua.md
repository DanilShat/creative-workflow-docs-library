# Skills — що це і навіщо

Ця папка винесена окремо, щоб не шукати скіли по всій бібліотеці.

## Що тут лежить

### 01_codex_engineering_skills.md
Які engineering-звички та правила повинен мати Codex під час реалізації:
- не халтурити
- не залишати критичні заглушки
- писати зрозумілі коментарі
- робити реальний E2E-шлях
- тримати код чистим і пояснюваним

### 02_agent_runtime_skills.md
Які runtime-скіли повинен мати сам оркестратор:
- нормалізація brief
- вибір наступного кроку
- маршрутизація skill/tool
- prompt repair через browser tools
- робота зі state машиною

### 03_browser_worker_skills.md
Які capability-скіли потрібні browser worker-у:
- Gemini prompt-building
- Freepik image flow
- Kling/Flow/Higgsfield video flows
- upload/download, retries, reauth

### 04_photoshop_aftereffects_skills.md
Які скіли потрібні для companion-інтеграцій:
- Photoshop host actions
- After Effects host actions
- allowlisted execution
- side panel / bridge behavior

### 05_operator_and_deploy_skills.md
Які операційні скіли потрібні системі та тобі як оператору:
- розгортання server/worker
- підняття локальної LLM
- перевірка heartbeat/job lifecycle
- перевірка retention/storage/paths

## Як використовувати

- Для розуміння продукту — прочитай усі файли в цій папці.
- Для Codex — дай йому прочитати ці файли **до початку коду**, щоб у нього був явний каталог skills.



# Нові reviewer skills

Перед імплементацією Codex має використовувати окремі reviewer skills:

- `system-architecture-reviewer/SKILL.md` — перевіряє систему як архітектуру: boundaries, data flow, deployment, security, evolution path.
- `spec-gap-reviewer/SKILL.md` — шукає суперечності, прогалини в спеках, неясні acceptance criteria.
- `implementation-review-gate/SKILL.md` — використовується після implementation brief або після коду, щоб не пропустити mock-only чи placeholder реалізацію.

Ці skills не повинні писати код. Їх задача — gatekeeping перед реалізацією.

## Додано v10

- `claude-mcp-delegate/SKILL.md` — як підключати Claude Desktop через MCP без перетворення Claude на ядро системи.
