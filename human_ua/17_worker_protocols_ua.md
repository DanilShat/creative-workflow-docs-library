# Протоколи між сервером і воркером

## Чого ми хочемо від протоколу

Протокол має бути не "демо-красивим", а таким, щоб система реально жила:
- воркер переживає короткі обриви зв'язку;
- job не губиться, якщо воркер впав;
- сервер знає, живий воркер чи ні;
- файли не пхаються в JSON;
- є явні lease, timeout і failure status.

## Базова модель

Для MVP беремо просту схему:
- HTTP API між сервером і воркером;
- polling для claim-next;
- heartbeat кожні 15 секунд;
- один активний job на воркері;
- progress updates під час виконання;
- multipart upload для артефактів.

## Мінімальний цикл життя воркера

1. Воркер стартує.
2. Реєструється через `register`.
3. Починає слати `heartbeat`.
4. Якщо idle — опитує сервер `claim-next` кожні 3 секунди.
5. Якщо отримав job — переводить себе в `running`.
6. Під час виконання шле progress та поновлює lease.
7. Після завершення завантажує артефакти і закриває job.

## Чому polling, а не push

Для живої MVP polling простіший і надійніший:
- не треба одразу піднімати складний bidirectional transport;
- менше проблем з reconnect;
- легше дебажити;
- легше тестувати двомашинну схему.

WebSocket можна додати пізніше для більш живого progress-streaming.

## Lease і stale job

Кожен claimed/running job має lease TTL.

Практична схема:
- lease TTL: 90 секунд;
- heartbeat interval: 15 секунд;
- якщо lease не поновлювався — сервер вважає job orphaned;
- orphaned job можна повернути в чергу або перевести в `needs_operator_review`.

## Основні статуси

### Worker status
- `starting`
- `idle`
- `busy`
- `degraded`
- `offline`

### Job status
- `queued`
- `claimed`
- `running`
- `uploading_artifacts`
- `waiting_human`
- `completed`
- `failed_retryable`
- `failed_fatal`
- `cancelled`
- `orphaned`

## Артефакти і файли

Правило просте:
- refs і metadata живуть на сервері;
- воркер завантажує потрібні refs по `asset_id`;
- результати воркер шле назад upload endpoint'ом;
- великі файли зберігаються як файли, а не як blob у БД.

## Capabilities

Під час реєстрації воркер має чесно сказати, що він уміє. Приклад:
- `browser.playwright`
- `browser.gemini`
- `browser.freepik`
- `browser.kling`
- `dcc.photoshop`
- `dcc.aftereffects`

Сервер не має права віддавати воркеру job, який не входить у його capabilities.
