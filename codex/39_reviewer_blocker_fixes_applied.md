# Reviewer blocker fixes — applied spec patch

## Authority
This file is an override layer over older specs. If any older file conflicts with this document, this document wins.

## B1 — First vertical slice acceptance

### Current decision
The first real implementation gate is the browser-first E2E slice:

1. Server starts on operator laptop.
2. Worker starts on designer laptop.
3. Worker registers and heartbeats.
4. Gemini and Freepik browser profiles are authenticated.
5. Server creates task and stores uploaded reference.
6. Local LLM produces structured brief/routing/job creation only.
7. Worker executes real Gemini browser prompt-builder flow.
8. Worker executes real Freepik browser image-generation flow.
9. Worker uploads generated artifact and debug artifacts.
10. Server records prompt/run/job/asset history.
11. Worker returns to idle.
12. Server workflow waits for human approve/reject.
13. Reject creates a new repair/retry job; previous attempts remain visible.

### DCC decision
Photoshop/After Effects are not part of the first browser E2E gate. They are separate milestone gates after the first vertical slice is working.
DCC contracts and skeletons may exist, but first MVP completion must not depend on fake Photoshop/AE execution.

### UI decision
The Gate A MVP UI default is Streamlit hosted on the operator laptop. FastAPI remains the backend/API surface for worker protocol, task state, artifact handling and orchestration services. The designer may open the Streamlit UI through the server URL, but the designer worker never owns task state or the main UI.

## B2 — Worker auth/bootstrap

### Token model
- The server owns worker identity and token validation.
- The canonical initial worker id for examples, runbook commands and first implementation is `designer-laptop-01`.
- Worker tokens are generated during setup, copied to the designer worker env, and stored server-side only as a hash.
- Tokens are sent as `Authorization: Bearer <WORKER_TOKEN>`.
- Tokens must never be logged.
- Ollama stays bound to localhost on the operator laptop and is never exposed directly to the worker.

### Bootstrap sequence
1. Operator runs `server worker-token create --worker-id designer-laptop-01`.
2. Server stores `sha256(token + server_secret)` or stronger password-hash equivalent.
3. Operator copies only the raw token into designer worker `.env`.
4. Worker starts with `SERVER_BASE_URL`, `WORKER_ID`, `WORKER_TOKEN`.
5. Worker calls `POST /api/v1/workers/register`.
6. Server validates token and `TRUSTED_WORKER_IDS`.
7. If registration is disabled and worker is unknown, server rejects with `403 registration_disabled`.
8. If token is revoked, all worker endpoints return `401 token_revoked`.

### Required server env
```env
DATABASE_URL=postgresql+psycopg://creative:creative@localhost:5432/creative_workflow
SERVER_PUBLIC_BASE_URL=http://192.168.1.10:8000
ARTIFACT_ROOT=D:/creative-workflow/artifacts
OLLAMA_BASE_URL=http://127.0.0.1:11434
OLLAMA_MODEL=gemma3n:e2b
SERVER_SECRET=<random-32-plus-bytes>
ALLOW_WORKER_REGISTRATION=false
TRUSTED_WORKER_IDS=designer-laptop-01
```

### Required worker env
```env
SERVER_BASE_URL=http://192.168.1.10:8000
WORKER_ID=designer-laptop-01
WORKER_TOKEN=<copied-token>
WORKER_TEMP_ROOT=C:/creative-workflow-worker/temp
PLAYWRIGHT_PROFILE_ROOT=C:/creative-workflow-worker/profiles
WORKER_CAPABILITIES=browser.playwright,browser.gemini,browser.freepik
```

## B3 — HTTP contract authority
The canonical endpoint schemas are in `codex/25_api_and_ws_surface.md`. Implementation must create shared Pydantic models or equivalent typed schemas from those contracts.

## B4 — Human review ownership
`waiting_human` is not a worker-job state.

Correct split:
- Worker job terminal state: `completed` after outputs/artifacts are uploaded.
- Server workflow state: `waiting_human_review` after job completion.
- Worker returns to `idle` before human approve/reject.
- Reject creates a new job; it does not keep the previous job leased.

## B5 — DCC ownership
Replace all ambiguous “local agent service plans actions” wording with:

- Server owns planning, orchestration, state and local LLM access.
- Worker owns browser/DCC execution on designer laptop.
- Photoshop/AE panels expose local context and execute allowlisted actions through the worker bridge.
- Panels may request server planning via worker/server protocol, but they do not own authoritative task state.
- Claude Desktop, if enabled, can invoke allowlisted MCP tools but does not own state.
