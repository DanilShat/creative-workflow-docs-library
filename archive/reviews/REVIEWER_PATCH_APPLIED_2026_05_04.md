# Reviewer patch applied — 2026-05-04

This version applies the Codex reviewer report as actual specification changes, not only as a report.

## Applied critical blockers

- **B1 — acceptance conflict fixed**: the first implementation gate is now browser-first Gemini + Freepik E2E. Photoshop/After Effects are post-slice gates and must not be faked to claim first MVP completion.
- **B2 — worker auth/bootstrap fixed**: worker token generation, hashing/storage, registration toggles, trusted worker ids, revocation and required environment variables are now specified.
- **B3 — HTTP contracts fixed**: canonical schemas are now defined for register, heartbeat, claim-next, progress, complete, fail, asset upload and asset download.
- **B4 — `waiting_human` ambiguity fixed**: human review is a server workflow state after worker job completion. Worker jobs do not remain leased while waiting for operator review.
- **B5 — DCC local-agent ambiguity fixed**: planning/state ownership belongs to the server. Designer-side bridges execute allowlisted actions only.

## Applied important gaps

- Browser profile lifecycle moved into the browser spec and runbook.
- Gemini/Freepik structured browser-flow result contracts added.
- Artifact upload metadata and path-safety rules added.
- Required scripts and expected outputs added.
- Local LLM JSON output schemas added.
- Superseded warnings added to older local-only docs.
- Manual live-browser evidence checklist added.

## Claude delegate integration added

Claude Desktop is now documented as an optional delegated orchestrator on the designer laptop via a local MCP server.
The core system must work without Claude.
Claude may read task context and invoke allowlisted worker/host actions through MCP, but it must not own authoritative state or execute arbitrary host code.
