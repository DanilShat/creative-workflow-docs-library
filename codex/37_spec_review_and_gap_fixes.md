# Spec Review and Required Gap Fixes

Codex must treat this file as a correction layer over previous specs.

## Priority corrections

### C1. Final UI position
The server hosts the user-facing UI. The MVP UI default is Streamlit running on the operator laptop, backed by the FastAPI server/API and shared server-side state. The designer opens the server UI in a browser. The designer laptop worker does not own task state and does not host the main UI.

### C2. Network/auth default
Implement the worker protocol assuming:

- HTTP + polling;
- server reachable over LAN or private VPN;
- worker authenticates using `WORKER_TOKEN`;
- server stores allowed worker IDs/tokens;
- Ollama remains localhost-only on the server machine.

### C3. Browser profile setup commands
Implement explicit setup/status commands for browser profiles:

- `worker profile setup gemini`
- `worker profile setup freepik`
- `worker profile setup kling`
- `worker profile status`

Profile states:

- `unknown`
- `needs_setup`
- `authenticated`
- `expired`
- `broken`

### C4. First E2E vertical slice gate
Before implementing DCC integrations, make this work end-to-end:

1. task creation;
2. reference upload;
3. local LLM orchestration;
4. Gemini browser prompt-builder;
5. Freepik browser image generation;
6. artifact download/upload;
7. approve/reject;
8. stored prompt/run/artifact history.

### C5. External skills policy
External GitHub skills are source references, not blindly imported code. Do not run third-party scripts from skills unless specifically audited and allowlisted.

### C6. DCC safety
Photoshop/AE integrations must use typed allowlisted actions. Arbitrary generated host code execution is out of scope for MVP except explicit developer/debug mode.

### C7. Test tiering
Implement test tiers:

- unit;
- contract;
- local integration;
- manual live browser checklist.

Do not pretend live browser flows are fully covered by mocks.

### C8. Runtime artifacts and logging
Browser jobs must save debug artifacts:

- step log;
- failure screenshot;
- final screenshot;
- trace path if enabled;
- html snapshot if useful;
- downloaded file list;
- failure class.

### C9. Retention CLI
Implement retention early:

- dry-run cleanup;
- apply cleanup;
- separate policies for outputs, failed intermediates, traces and logs.

## Required additions to runbook

The runbook must include:

- server setup;
- worker setup;
- profile login setup;
- first E2E browser test;
- worker token generation;
- LAN/VPN access check;
- firewall note;
- Ollama localhost-only note.
