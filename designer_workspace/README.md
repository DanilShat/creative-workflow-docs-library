# Designer Workspace

This folder is what gets dropped onto a designer's laptop so Claude Desktop becomes their creative workflow agent. **You only set this up once per laptop.**

## What's in here

- **`DESIGNER_SYSTEM_PROMPT.md`** — paste into Claude Desktop → New Project → System Prompt. Tells Claude how to talk like a creative collaborator and which tools it has.
- **`sample_briefs/`** — natural-language briefs that work end-to-end. Use them as templates for your own work.

## Setup (5 minutes)

1. Make sure the worker repo is installed and `.env.worker` is filled in. (See `creative-workflow-worker/README.md`.)
2. Register the MCP server with Claude Desktop:
   ```powershell
   cd <worker-repo-root>
   powershell -NoProfile -ExecutionPolicy Bypass -File `
     .\scripts\register_mcp_with_claude_desktop.ps1 `
     -PythonExe "<path-to-your-venv>\Scripts\python.exe" `
     -EnvFile "<absolute-path-to>\.env.worker"
   ```
3. Restart Claude Desktop.
4. In Claude Desktop, open **Settings → Developer**. You should see `creative-workflow` listed under MCP servers with a green "running" indicator.
5. Create a new Project named **"Creative Workflow"**. Paste the contents of `DESIGNER_SYSTEM_PROMPT.md` into the project's system prompt.
6. Open a chat in that project. Type `/` — you should see three slash-menu items: `brief-to-variants`, `psd-handoff`, `reels-render`.

## Daily use

Open the **Creative Workflow** project in Claude Desktop. Either:

- Type `/brief-to-variants`, fill in the task ID and brief, send. Claude will run the variant pipeline and show thumbnails inline.
- Or just type freely: *"What jobs ran on task `task_abc123` today? Show me the artifacts."* The agent uses `get_context` and `list_artifacts` to answer.

## What's available right now

- **`get_context`** — fetch the brief and job history for any task.
- **`list_artifacts`** — see generated assets, with image thumbnails rendered inline.
- **`request_review`** — record approve/reject decisions back to the operator.
- **`submit_browser_job`** — create or fan out Gate A browser jobs through the operator queue.
- **`submit_aftereffects_render`** — render a named AE comp through local `aerender.exe` when After Effects is installed.

## What's coming

| | |
|---|---|
| **B2 hardening** | Photoshop UXP panel packaging and real Photoshop validation. |
| **B3 hardening** | Real After Effects validation with a sample `.aep` project on the designer laptop. |

## Troubleshooting

- **Slash menu doesn't show the workflows.** Restart Claude Desktop. Check `Settings → Developer → MCP servers` for an error indicator.
- **Tools fail with 401/403.** Your `WORKER_TOKEN` in `.env.worker` is missing or expired. Get a fresh one from the operator (`docker_operator_worker_token.ps1`).
- **Tools fail with connection refused.** The operator isn't running, or `SERVER_BASE_URL` in `.env.worker` points to the wrong host. Run `ipconfig` on the operator laptop and update.
