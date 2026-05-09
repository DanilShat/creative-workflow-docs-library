# Дані та зберігання

## Загальний принцип
У БД зберігаємо **метадані**.
Файли зберігаємо **на диску**.

## Локальна структура папок

```text
workspace/
  tasks/
    {task_id}/
      refs/
      generated/
      selected/
      exports/
      logs/
      temp/
```

## Що зберігати в PostgreSQL
- tasks
- scenes
- assets
- prompts
- runs
- reviews
- routing_events

## Retention policy
- selected assets — зберігати;
- refs — зберігати;
- intermediate previews — чистити через 14–30 днів;
- temp files — чистити швидше;
- raw screenshots/debug dumps — зберігати тільки при помилках або в debug mode.
