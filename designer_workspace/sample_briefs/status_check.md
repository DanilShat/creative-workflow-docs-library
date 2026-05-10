# Sample brief — Quick status check (B0)

Useful when you walk back to your desk and want to know what happened while you were away.

---

What jobs ran on task `[task_id_here]` today? Show me the latest artifacts inline.

---

Expected behavior: Claude calls `get_context` to list jobs, then `list_artifacts(limit=10, inline_images=true)` and renders thumbnails. If anything failed, it names which job and why in one sentence.
