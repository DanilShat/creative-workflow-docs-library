# CURRENT TOPOLOGY WARNING

This older file is superseded where it conflicts with:
- `codex/21_server_worker_architecture.md`
- `codex/39_reviewer_blocker_fixes_applied.md`
- `codex/30_server_worker_acceptance_suite.md`

Current topology: server/control plane runs on operator laptop; worker/execution plane runs on designer laptop. First MVP gate is Gemini + Freepik browser E2E. DCC comes after Gate A.

---

# Acceptance Criteria

## General
- app starts locally with documented setup steps;
- user can create a task and upload refs;
- metadata is persisted in PostgreSQL;
- files are written to local workspace folders.

## Static workflow
- system can create initial prompt from brief;
- system can execute one provider generation flow through browser automation;
- generated outputs are stored and indexed;
- user can approve or reject a candidate;
- rejection creates a review record and enables another iteration.
