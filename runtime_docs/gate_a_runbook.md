# Gate A Runbook

## One-script operator setup

Run this on the operator laptop:

```powershell
cd D:\design_agent_pet_project\creative_workflow_docs_library
powershell -ExecutionPolicy Bypass -File .\scripts\setup_operator_and_package_designer.ps1
```

This script:

1. installs the Python package;
2. creates `.env.server`;
3. runs `server config check`;
4. checks the local Ollama model;
5. runs database migration;
6. creates a token for `designer-laptop-01`;
7. creates `dist\designer_worker_package.zip`.

Copy `dist\designer_worker_package.zip` to the designer laptop.

If PostgreSQL is not installed or not running yet, install/start PostgreSQL first, then rerun the script.
If Ollama is not running or the configured model is missing, start Ollama and pull the model, then rerun the script.

## One-script designer setup

On the designer laptop:

```powershell
Expand-Archive .\designer_worker_package.zip -DestinationPath .\designer_worker_package
cd .\designer_worker_package
powershell -ExecutionPolicy Bypass -File .\setup_designer_one_click.ps1
```

This script installs dependencies, installs Playwright Chromium, checks the worker config, checks server reachability, and opens Gemini/Freepik profile setup.

## Manual operator laptop commands

```powershell
cd D:\design_agent_pet_project\creative_workflow_docs_library
python -m pip install -e ".[test]"
Copy-Item .env.server.example .env.server
notepad .env.server
server config check
server llm healthcheck
server db migrate
server worker-token create --worker-id designer-laptop-01
server dev --host 0.0.0.0 --port 8000
```

In a second terminal on the operator laptop:

```powershell
cd D:\design_agent_pet_project\creative_workflow_docs_library
server ui --port 8501
```

## Designer laptop

```powershell
cd D:\design_agent_pet_project\creative_workflow_docs_library
python -m pip install -e ".[test]"
python -m playwright install chromium
Copy-Item .env.worker.example .env.worker
notepad .env.worker
python -m creative_workflow.worker.cli config check
python -m creative_workflow.worker.cli healthcheck
python -m creative_workflow.worker.cli profile setup gemini
python -m creative_workflow.worker.cli profile setup freepik
python -m creative_workflow.worker.cli profile status
python -m creative_workflow.worker.cli run
```

## Notes

- `SERVER_PUBLIC_BASE_URL` must be reachable from the designer laptop.
- `OLLAMA_BASE_URL` must stay `http://127.0.0.1:11434` on the operator laptop.
- The first worker id is `designer-laptop-01`.
- Photoshop, After Effects, and Claude MCP are not required for Gate A.
- If Freepik Google login requires an already trusted daily browser session,
  stop trying to clone Chrome cookies for Gate A. That path is tracked in
  `runtime_docs/v2_claude_desktop_browser_automation.md` and should be handled
  by a V2 Claude/desktop UI automation executor.
- Photoshop/AE bridge classes are expected to report `photoshop_not_connected` or `aftereffects_not_connected` until the later DCC gate.
- To validate stale leases manually, stop the worker during an active job, wait longer than 90 seconds, then run `python -m creative_workflow.server.cli mark-orphans`.
