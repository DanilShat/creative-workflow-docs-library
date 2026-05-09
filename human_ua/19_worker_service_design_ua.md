# Дизайн worker service

## Що таке worker service

Worker service — це фонова програма на ноутбуці дизайнера, яка виконує jobs від сервера.

Це не просто один скрипт. Це окремий локальний сервіс із модулями.

## Склад воркера

### 1. Core coordinator
Відповідає за:
- старт;
- реєстрацію;
- heartbeat;
- polling;
- маршрутизацію job у потрібний executor.

### 2. Browser executor
Виконує Playwright flows:
- Gemini prompt builder;
- Freepik image/video flows;
- Kling flows;
- інші browser-first інтеграції.

### 3. Photoshop executor
Працює через локальний companion/panel і виконує allowlisted host actions.

### 4. After Effects executor
Працює через локальний bridge і виконує вузький каталог дій.

### 5. Asset manager
- качає refs із сервера;
- кладе їх у локальний temp workspace;
- вантажить результати назад;
- чистить тимчасові файли.

### 6. Telemetry / debug layer
- step logs;
- screenshots;
- browser traces;
- error context.

## Один job за раз

Для MVP воркер виконує **один активний job за раз**.

Це свідоме рішення, а не слабкість. Воно дає:
- простішу синхронізацію;
- менше конфліктів із Photoshop/AE;
- менше гонок за браузерні профілі;
- реальнішу стабільність.

## Worker state machine

- `starting`
- `registering`
- `idle`
- `claiming`
- `preparing`
- `running`
- `uploading`
- `waiting_human`
- `error`
- `stopping`

## Які помилки треба вміти пережити

- браузер не відкрився;
- сесія розлогінилась;
- Photoshop не запущений;
- After Effects не відповідає;
- download зірвався;
- upload артефакта не вдався;
- мережа тимчасово пропала.

## Головний принцип

Воркер не повинен мати всередині "вільний агент".

Він виконує лише:
- зареєстровані browser flows;
- allowlisted host actions;
- явні file operations.
