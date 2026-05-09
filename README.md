# Creative Workflow Gate A Runtime

This repository now contains the first real MVP implementation for the
browser-first Gate A slice.

Gate A runs as two machines:

- operator laptop: FastAPI, Streamlit, PostgreSQL, artifact storage, local LLM
- designer laptop: worker service, Playwright profiles, Gemini/Freepik browser flows

Start with `runtime_docs/gate_a_runbook.md`.

