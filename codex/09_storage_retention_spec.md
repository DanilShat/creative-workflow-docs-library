# Storage and Retention Specification

## Principle
Store metadata in PostgreSQL and files on local disk.

## Workspace layout

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
  browser_profiles/
  downloads/
  traces/
```

## Retention rules
- keep approved outputs indefinitely unless user deletes task;
- keep refs indefinitely;
- remove temp files older than N days;
- remove unselected generated outputs older than N days.
