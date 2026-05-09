# Архітектура

## Верхній рівень

```text
Streamlit UI
  ->
Application Service Layer
  ->
LangGraph Orchestrator
  ->
Provider Layer
    - Browser adapters
    - Future API adapters
  ->
PostgreSQL metadata
  +
Local filesystem storage
```

## Головні принципи

### 1. State-first
Система повинна завжди знати:
- що за задача;
- який тип задачі;
- які є рефи;
- який поточний промпт;
- що вже пробували;
- чому відхилили попередню версію;
- який артефакт обраний фінально.

### 2. Browser-first
Бо у агентства немає API-доступу. Це означає:
- кроки генерації йдуть через браузерні сесії;
- треба окремий automation layer;
- vendor-specific UI не повинен залазити в бізнес-логіку workflow.

### 3. Human-in-the-loop
Людина не прибирається з процесу. Вона:
- підтверджує бриф, якщо є неясності;
- приймає/відхиляє кандидати;
- може вручну правити промпт;
- вирішує, коли результат досить добрий.
