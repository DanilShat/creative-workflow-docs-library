# CURRENT TOPOLOGY WARNING

This older file is superseded where it conflicts with:
- `codex/21_server_worker_architecture.md`
- `codex/39_reviewer_blocker_fixes_applied.md`
- `codex/30_server_worker_acceptance_suite.md`

Current topology: server/control plane runs on operator laptop; worker/execution plane runs on designer laptop. First MVP gate is Gemini + Freepik browser E2E. DCC comes after Gate A.

---

# Streamlit UI Specification

## MVP ownership
Streamlit is the default Gate A UI and runs on the operator laptop. It reads and writes task state through server-side services only; the designer worker never hosts the main UI or owns workflow state.

## Layout
Two-column layout.

### Left column
- chat log / event timeline
- task intake form
- system questions
- user responses

### Right column
- task summary
- refs preview
- current prompt
- current provider
- attempts history
- outputs grid
- review controls
