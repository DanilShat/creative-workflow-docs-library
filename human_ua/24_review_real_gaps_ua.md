# Ревізія спек: реальні прогалини без фанатизму

## Висновок

Бібліотека вже достатньо сильна, щоб починати розробку. Головне рішення правильне:

- сервер, БД, LangGraph і локальна LLM — на ноуті власника;
- браузери, Photoshop і After Effects — на ноуті дизайнерки;
- LLM локально використовується тільки як оркестратор;
- генеративні сервіси працюють через браузерні флоу;
- Photoshop/AE працюють через allowlisted actions.

## Що треба поправити перед активною розробкою

### 1. Чіткий спосіб підключення worker до server

Потрібно зафіксувати default:

- один LAN або приватний mesh VPN;
- worker підключається до server через HTTP polling;
- worker має токен;
- Ollama не відкривається назовні;
- назовні доступний тільки backend/UI.

### 2. Browser profiles як окремий first-run етап

Для Gemini, Freepik, Kling тощо треба окремо прогнати login setup:

- відкрити браузерний profile;
- залогінитись руками;
- worker перевіряє, що сесія жива;
- якщо сесія протухла — job переходить в `needs_reauth`.

### 3. Skills з GitHub треба не копіювати сліпо

Ми можемо брати найкращі репозиторії як джерела і патерни, але не тягнути чужі scripts без аудиту. Для нашого MVP skills мають бути власними, адаптованими під наші спеки, з attribution.

### 4. Перший вертикальний slice має бути жорстким

До Photoshop/AE не треба лізти, поки не працює:

1. task на server;
2. ref upload;
3. local LLM orchestration;
4. Gemini browser prompt-builder;
5. Freepik browser image generation;
6. artifact upload;
7. approve/reject;
8. history у БД.

### 5. Photoshop/AE тільки через allowlisted actions

Не давати агенту виконувати довільний ExtendScript/JS у MVP. Дозволені тільки типізовані дії з каталогу.

### 6. Тести мають мати manual live tier

Живі браузерні сайти не можна чесно повністю протестувати unit-тестами. Має бути окремий manual live checklist для реального Gemini/Freepik flow.

### 7. Логи мають бути support-first

Кожен browser job має зберігати:

- step log;
- screenshot;
- screenshot on failure;
- Playwright trace;
- failure class;
- список artifacts.

### 8. Retention треба реалізувати рано

Щоб база і диск не перетворилися на смітник:

- фінальні artifacts зберігати;
- failed intermediates чистити через 14 днів;
- traces чистити через 7 днів;
- зробити cleanup dry-run.

## Підсумок

Немає потреби переробляти всю архітектуру. Треба лише ущільнити операційні моменти, безпеку skills і first-run path.
