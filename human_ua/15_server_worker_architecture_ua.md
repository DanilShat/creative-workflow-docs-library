# Архітектура server/worker

## Головна ідея

Система ділиться на дві машини:

### 1. Control plane на ноутбуці власника системи
Тут працюють:
- FastAPI backend;
- LangGraph orchestration;
- локальна LLM для оркестратора;
- PostgreSQL;
- централізована історія задач, jobs, логів та артефактів.

### 2. Execution plane на ноутбуці дизайнера
Тут працюють:
- worker service;
- Playwright browser flows;
- Photoshop companion;
- After Effects bridge;
- локальний тимчасовий кеш файлів.

## Чому саме так

Ця архітектура дає реальну, а не демо-версію системи:
- "мозок" системи централізований;
- браузерні сесії живуть там, де ними реально користується дизайнер;
- Photoshop і After Effects керуються на тій машині, де вони встановлені;
- стан задач і логіка workflow не розмазуються по двох ноутбуках.

## Що робить сервер

Сервер:
- приймає нові задачі;
- нормалізує brief;
- вирішує, який наступний крок потрібен;
- ставить jobs у чергу;
- віддає jobs сумісному воркеру;
- приймає progress, логи, статуси та артефакти;
- тримає повний audit trail.

## Що робить воркер

Воркер:
- реєструється на сервері;
- шле heartbeat;
- заявляє capabilities;
- бере jobs;
- виконує browser flows або host actions;
- відправляє результати назад на сервер.

## Ключове правило

Локальна LLM на сервері **не** генерує зображення, відео або аудіо. Вона лише:
- розкладає задачу на кроки;
- вибирає, який tool/skill викликати;
- формує структуровані payloads;
- вирішує, коли потрібен повтор, review або ескалація людині.

## Реальна мінімальна конфігурація

### На сервері
- FastAPI
- LangGraph
- PostgreSQL
- локальний model runtime (наприклад, Ollama)
- файлове сховище артефактів

### На воркері дизайнера
- Python worker service
- Playwright + browser profiles
- Photoshop plugin/panel
- After Effects bridge
- фоновий uploader/downloader

## Принципи живої MVP

- один server instance;
- один worker instance;
- один активний job за раз на воркері;
- без моків у happy path;
- всі інтеграції працюють через реальні браузери та реальні host applications;
- усі проблеми мають явні статуси: `needs_reauth`, `needs_human`, `retryable_failure`, `fatal_failure`.
