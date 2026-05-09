# Spec Review — Real Gaps and Practical Fixes

Date: 2026-05-04

This review focuses only on gaps that can block a real working MVP. It deliberately avoids speculative enterprise features.

## Overall verdict

The current specs are strong enough to start implementation. The main architecture is coherent:

- server/control plane on the owner laptop;
- worker/execution plane on the designer laptop;
- local LLM only for orchestration;
- browser-first execution for Gemini/Freepik/Kling/etc.;
- Photoshop and After Effects through allowlisted bridges;
- metadata in PostgreSQL, binary artifacts on disk.

The biggest remaining risks are not the high-level architecture. They are operational details: auth, networking, skill provenance, real browser sessions, Windows setup, and first-run validation.

## Gap 1 — Network/auth between server and worker needs a concrete default

### Problem
The specs define heartbeat, polling, leases and job states, but they do not fully define the practical connection model across two laptops.

### Fix
Use this MVP default:

- primary mode: same trusted LAN;
- optional safer remote mode: Tailscale or equivalent private mesh VPN;
- never expose Ollama directly;
- server exposes only FastAPI app port;
- worker authenticates with a pre-shared worker token generated during setup;
- token is stored in `.env` on designer laptop;
- server can revoke worker token.

### Required Codex addition
Add config fields:

- `SERVER_PUBLIC_BASE_URL`
- `WORKER_ID`
- `WORKER_TOKEN`
- `ALLOW_WORKER_REGISTRATION=false|true`
- `TRUSTED_WORKER_IDS`

## Gap 2 — Browser profile/session lifecycle needs explicit operator steps

### Problem
Browser automation depends on real logged-in sessions. Specs mention persistent profiles, but not the full lifecycle.

### Fix
Add a first-run profile setup mode:

- `worker browser setup gemini`
- `worker browser setup freepik`
- `worker browser setup kling`

The command opens headed Chromium, user logs in manually, then the worker validates the session and records `authenticated=true`.

### Required Codex addition
Implement `profile_status` per service:

- `unknown`
- `needs_setup`
- `authenticated`
- `expired`
- `broken`

## Gap 3 — Skill provenance/security needs stricter rules

### Problem
The project now uses external GitHub skill inspiration. External skills may include scripts or unsafe assumptions.

### Fix
Do not import third-party scripts blindly. Use external repos as references, then write project-specific skills with:

- source attribution;
- no bundled executable external scripts;
- no raw arbitrary code execution;
- allowlisted commands only;
- explicit trust level per source.

## Gap 4 — UI ownership is slightly ambiguous after moving to two-machine architecture

### Problem
Earlier specs mention Streamlit local UI. Later specs move orchestration to server and execution to designer worker. The UI needs one final position.

### Fix
MVP UI should run on the server laptop and be accessed by the designer through a browser URL. The worker runs separately on the designer laptop. Do not put business state in the worker UI.

### Required Codex addition
Clarify:

- server hosts Streamlit or FastAPI-served UI;
- designer opens `http://SERVER_IP:PORT` or Tailscale URL;
- worker has only minimal tray/CLI/status UI.

## Gap 5 — First vertical slice should be stricter

### Problem
Specs list many milestones. Codex might try to build too much before validating one real path.

### Fix
First real E2E must be:

1. create task on server;
2. upload one reference image;
3. local LLM creates structured brief/routing decision;
4. worker runs Gemini browser prompt-builder;
5. worker runs Freepik browser image generation;
6. result is downloaded/uploaded;
7. user approves/rejects;
8. server stores prompt/run/artifact history.

DCC integrations come after this path works.

## Gap 6 — Photoshop/After Effects execution must remain allowlisted

### Problem
Some external Adobe skills generate and execute arbitrary ExtendScript. That is powerful but too risky for this MVP.

### Fix
Use external Adobe/AE skills as design inspiration only. MVP must run typed host actions, not arbitrary generated scripts, unless there is an explicit manual developer/debug mode.

## Gap 7 — Testing needs a real-browser/manual test tier

### Problem
Automated unit/contract tests cannot fully prove Gemini/Freepik browser flows work, because those sites change and require live accounts.

### Fix
Split tests into:

- unit tests: schemas, routing, state transitions;
- contract tests: server-worker protocol and artifact upload;
- local integration tests: worker lifecycle against a dev server;
- manual live tests: browser login and one real generation.

Do not fake live browser flows as passing automated tests.

## Gap 8 — Logs must be support-oriented

### Problem
Browser automation will break. The operator needs fast diagnosis.

### Fix
Every browser job stores:

- step log;
- final screenshot;
- screenshot on failure;
- Playwright trace if enabled;
- downloaded file list;
- profile/service status;
- failure class.

## Gap 9 — Retention/cleanup should be implemented early

### Problem
Generated media can grow quickly.

### Fix
Implement cleanup from M1/M2:

- selected/final artifacts are kept;
- failed intermediate artifacts default retention: 14 days;
- debug traces default retention: 7 days;
- operator command: `cleanup --dry-run` then `cleanup --apply`.

## Gap 10 — Installation scripts should be boring and explicit

### Problem
Windows setup across two machines can become the biggest friction.

### Fix
Add scripts:

- `scripts/setup_server_windows.ps1`
- `scripts/setup_worker_windows.ps1`
- `scripts/check_server_health.ps1`
- `scripts/check_worker_health.ps1`

Each script must print what it checks and what the next manual step is.

## Final recommendation

Keep architecture as-is. Do not expand scope. Improve the library by adding:

1. external-source-backed skills;
2. explicit server/worker network/auth setup;
3. browser profile setup lifecycle;
4. first vertical slice acceptance gate;
5. manual live browser test checklist;
6. tighter security rule: no imported unreviewed scripts, no arbitrary generated DCC code in MVP.
