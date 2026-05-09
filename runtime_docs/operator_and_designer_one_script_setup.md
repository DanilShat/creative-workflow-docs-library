# One-Script Setup Guide

This guide is the operator-friendly setup path for Gate A.

Gate A still needs a few manual actions because the system uses real local
software and real browser accounts. The scripts remove repeated command typing;
they do not hide infrastructure requirements.

## What runs where

Operator laptop:

- FastAPI server
- Streamlit UI
- PostgreSQL metadata database
- artifact storage folder
- Ollama-compatible local LLM on `127.0.0.1`

Designer laptop:

- worker process
- Playwright Chromium
- persistent Gemini profile
- persistent Freepik profile

## Before running the operator script

Install or confirm these on the operator laptop:

1. Python 3.11+.
2. PostgreSQL running locally.
3. Ollama or compatible local LLM runtime.
4. A small model pulled in Ollama, for example the model named in `.env.server`.

Why this is manual:

- PostgreSQL installation differs by machine and may require admin rights.
- Ollama/model setup is operator-owned and must stay local to the operator laptop.
- The app must not expose Ollama directly to the designer laptop.

Quick check:

```powershell
ollama list
```

The configured model, for example `gemma3n:e2b`, should appear in the list.

## Operator one-script command

Run:

```powershell
cd D:\design_agent_pet_project\creative_workflow_docs_library
powershell -ExecutionPolicy Bypass -File .\scripts\setup_operator_and_package_designer.ps1
```

Optional parameters:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup_operator_and_package_designer.ps1 `
  -ServerBaseUrl "http://192.168.1.10:8000" `
  -DatabaseUrl "postgresql+psycopg://creative:creative@localhost:5432/creative_workflow" `
  -ArtifactRoot "D:/creative-workflow/artifacts" `
  -OllamaModel "gemma3n:e2b"
```

The script creates:

- `.env.server`
- a worker token for `designer-laptop-01`
- `dist\designer_worker_package.zip`

If `.env.server` already contains a real `SERVER_SECRET`, the script preserves
it. This matters because existing worker-token hashes depend on that secret.

Copy `dist\designer_worker_package.zip` to the designer laptop.

If Ollama is not running yet, the script will fail at the local LLM check. Start
Ollama or rerun the script with `-SkipLlmCheck` only if you are intentionally
checking packaging before the full runtime is ready.

## Start the operator services

Terminal 1:

```powershell
cd D:\design_agent_pet_project\creative_workflow_docs_library
python -m creative_workflow.server.cli dev --host 0.0.0.0 --port 8000
```

Terminal 2:

```powershell
cd D:\design_agent_pet_project\creative_workflow_docs_library
python -m creative_workflow.server.cli ui --port 8501
```

Open Streamlit at:

```text
http://localhost:8501
```

## Designer one-script command

On the designer laptop:

```powershell
Expand-Archive .\designer_worker_package.zip -DestinationPath .\designer_worker_package
cd .\designer_worker_package
powershell -ExecutionPolicy Bypass -File .\setup_designer_one_click.ps1
```

The archive already contains a prefilled `.env.worker` with:

- `SERVER_BASE_URL`
- `WORKER_ID=designer-laptop-01`
- `WORKER_TOKEN`

If the operator laptop IP changed, edit `.env.worker` and update `SERVER_BASE_URL`.

## Manual browser login steps

During designer setup, two browser windows open:

1. Gemini
2. Freepik

Log in manually in each browser, then return to PowerShell and press Enter when the script asks.

Why this is manual:

- Gemini and Freepik use consumer web sessions, not project API keys.
- The worker must use a real persistent browser profile.
- The system must not store your Gemini or Freepik password.
- CAPTCHA, 2FA, and provider login flows cannot be automated safely.

## Start the designer worker

After setup:

```powershell
cd .\designer_worker_package
python -m creative_workflow.worker.cli run
```

## First live Gate A validation

1. Confirm server is running on operator laptop.
2. Confirm Streamlit is running.
3. Confirm designer worker is running and heartbeating.
4. In Streamlit, create a task and upload one reference image.
5. Start Gate A.
6. Confirm Gemini creates a structured prompt and debug artifacts.
7. Confirm Freepik downloads a real generated file.
8. Confirm the task enters `waiting_human_review`.
9. Confirm the worker is idle before review.
10. Reject the result and confirm a new retry job is created.
11. For reliability validation, stop the worker during an active browser job and run `python -m creative_workflow.server.cli mark-orphans` after the lease expires.
12. Confirm the interrupted job becomes `orphaned` in task history or the database.

## Photoshop and After Effects boundary

Photoshop and After Effects are not started for Gate A. The worker bridge classes
exist only to return explicit `photoshop_not_connected` or
`aftereffects_not_connected` failure classes if such a job is attempted. Do not
count Photoshop/AE as passing until a later Gate B runbook connects real host
software and executes allowlisted actions.

## Common fixes

If designer cannot reach server:

- Check both laptops are on the same LAN or VPN.
- Check Windows Firewall allows port `8000` on the operator laptop.
- Check `.env.worker` has the operator laptop LAN URL, not `localhost`.

If `server db migrate` fails:

- Start PostgreSQL.
- Check `DATABASE_URL` in `.env.server`.
- Confirm the database and user exist.

If profile status is not authenticated:

- Rerun `python -m creative_workflow.worker.cli profile setup gemini`.
- Rerun `python -m creative_workflow.worker.cli profile setup freepik`.
