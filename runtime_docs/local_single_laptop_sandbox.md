# Local Single-Laptop Sandbox

Use this mode to test the operator UI, API, database, local LLM routing, worker
registration, heartbeat, job claiming, file transfer, and most worker behavior
on the operator laptop before involving the designer laptop.

This mode simulates the designer worker on the same machine with:

- server URL `http://127.0.0.1:8000`
- UI URL `http://127.0.0.1:8501`
- worker id `local-sim-worker-01`
- local worker temp/profile root under `D:\creative-workflow-local`

It does not replace the real two-laptop validation. Anything involving the
designer's real logged-in browser, Photoshop, After Effects, or Claude Desktop
still needs the designer laptop.

## One-Time Setup

```powershell
cd D:\design_agent_pet_project\creative_workflow_docs_library
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\setup_local_sandbox.ps1
```

This creates:

- `.env.server.local`
- `.env.worker.local`
- local worker token for `local-sim-worker-01`
- desktop shortcuts for local sandbox start/stop/UI

The local env files are ignored by git.

## Start

```powershell
cd D:\design_agent_pet_project\creative_workflow_docs_library
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\start_local_sandbox.ps1
```

Open:

```text
http://127.0.0.1:8501
```

## Status

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\status_local_sandbox.ps1
```

Logs live under:

```text
runtime_logs\local_sandbox\
```

## Stop

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\stop_local_sandbox.ps1
```

## What To Test Locally First

- Streamlit chat-first UI behavior
- task creation and reference upload
- local LLM health/routing fallback
- worker registration and heartbeat
- job claim lifecycle
- artifact storage and download
- retry/failure state transitions
- Gemini profile setup against a local sandbox profile

## What Not To Treat As Proven Locally

- designer laptop network reachability
- designer's real Google/Freepik browser session
- Freepik Google OAuth behavior
- Claude Desktop controlling the designer's real browser
- Photoshop/After Effects host bridges
