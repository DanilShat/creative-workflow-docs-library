# Browser-first automation

## Чому browser-first
У агентства немає API-викликів і все робиться через звичайні веб-інтерфейси сервісів.

## Потрібні компоненти
- browser session manager
- vendor flow adapters
- downloader
- watcher / waiter
- error recovery

## Persistent browser profile
Щоб не логінитися щоразу, треба використовувати окремий локальний browser profile.

## Що треба передбачити
- headed mode для налагодження;
- slow mode для flaky UI;
- таймаути;
- повторні спроби;
- зрозумілі user-facing помилки;
- ручний takeover, якщо сервіс попросив captcha або змінив інтерфейс.
