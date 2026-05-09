# CURRENT TOPOLOGY WARNING

This older file is superseded where it conflicts with:
- `codex/21_server_worker_architecture.md`
- `codex/39_reviewer_blocker_fixes_applied.md`
- `codex/30_server_worker_acceptance_suite.md`

Current topology: server/control plane runs on operator laptop; worker/execution plane runs on designer laptop. First MVP gate is Gemini + Freepik browser E2E. DCC comes after Gate A.

---

# Milestones

## Milestone 1 — Project scaffold
- repository skeleton
- config
- DB connection
- local workspace paths
- Streamlit shell
- basic logging

## Milestone 2 — Persistence model
- SQLAlchemy models
- Alembic migrations
- repositories
- asset/file registry

## Milestone 3 — Static workflow MVP
- task intake
- brief normalization
- prompt creation
- one browser-backed image generation flow
- review loop
- prompt repair
- export package
