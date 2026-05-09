# Локальний деплой і операційні правила

## Серверний ноутбук

На ноутбуці власника системи запускаються:
- FastAPI backend;
- LangGraph runner;
- локальна LLM runtime;
- PostgreSQL;
- artifact storage index;
- admin/debug UI.

## Ноутбук дизайнера

На ноутбуці дизайнера запускаються:
- worker service;
- Playwright browser runtime;
- Photoshop panel bridge;
- After Effects bridge;
- локальна папка тимчасових файлів.

## Рекомендований режим мережі

Для MVP достатньо локальної мережі:
- обидві машини в одній Wi-Fi або Ethernet мережі;
- сервер слухає внутрішню адресу;
- воркер знає URL сервера;
- доступ дається через worker token.

## Що треба для стабільності

- окремий workspace root на диску;
- cleanup policy для previews і тимчасових файлів;
- логування всіх jobs;
- trace artifacts для browser automation;
- heartbeat timeout для визначення мертвого воркера.

## Що не треба робити на старті

- не виставляти сервер одразу в інтернет;
- не робити складний multi-tenant auth;
- не будувати кластер;
- не намагатись запускати Adobe-програми на серверному ноутбуці.

## Що важливо для передпроду

Навіть якщо це поки ноутбук, треба поводитись як із сервером:
- мати конфігурацію через env;
- мати backup бази;
- мати список портів;
- мати health endpoints;
- мати restart plan для backend і worker.
