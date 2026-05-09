# Впроваджені правки після Codex-reviewer звіту

## Що змінилося

Reviewer правильно знайшов кілька місць, де Codex міг би побудувати не той MVP. У цій версії правки не просто записані як звіт, а впроваджені в технічні спеки.

## Головні рішення

1. Перший MVP gate — це **Gemini + Freepik browser E2E**, без Photoshop/AE.
2. Photoshop/After Effects — окремий наступний gate після робочого browser slice.
3. Worker auth/bootstrap тепер описаний конкретно: token generation, hashing, trusted worker ids, revocation.
4. HTTP endpoint contracts тепер мають конкретні request/response schemas.
5. Human review живе на сервері як workflow state, а не як активний worker job.
6. DCC-панелі не планують самі: сервер планує, worker/bridge виконує.
7. Claude доданий як опційний delegated orchestrator через MCP, але не як ядро.

## Як тепер давати Codex завдання

Перед реалізацією дай Codex промпт:
- `prompts/07_apply_v10_reviewer_patch_and_claude_delegate.md`

Після цього можна переходити до:
- `prompts/02_build_real_mvp.md`

Але памʼятай: `02_build_real_mvp` тепер означає Gate A, тобто браузерний E2E.
