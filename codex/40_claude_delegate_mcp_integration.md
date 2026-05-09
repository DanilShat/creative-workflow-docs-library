# Claude Delegate MCP Integration Spec

## Purpose
Add Claude Desktop on the designer laptop as an optional delegated orchestrator for complex creative reasoning and Adobe-heavy tasks.

The core product must work without Claude. Claude is an enhancement layer.

## Important product boundary
A Claude Pro/Max subscription gives access to Claude apps and Claude Code, but it is not the same as an Anthropic API key for server-side programmatic calls.

Therefore the MVP integration mode is:

```text
Claude Desktop on designer laptop
  -> local MCP server
  -> designer worker tools
  -> server state through worker/server APIs
```

Do not implement server-side Claude calls unless a separate Anthropic API key is explicitly configured.

## Components

```text
designer_laptop/
  worker_service/
  claude_mcp_server/
    server.py
    tools/
      task_context_tools.py
      review_tools.py
      browser_flow_tools.py
      photoshop_tools.py
      aftereffects_tools.py
    safety/
      allowlist.py
      confirmation_policy.py
      schemas.py
```

## Roles

### Server
- authoritative state owner
- task/run/job/asset database owner
- local LLM default orchestrator owner
- job queue owner
- approval/rejection workflow owner

### Worker
- authenticated execution client
- browser flow executor
- Photoshop/After Effects bridge executor
- artifact uploader

### Claude Desktop
- optional delegated reasoning/operator UI
- can inspect task context through MCP tools
- can propose plans
- can call allowlisted tools
- cannot bypass worker protocol
- cannot directly write DB state
- cannot execute arbitrary Photoshop/AE code

## Integration modes

### Mode A — Claude-initiated
Designer opens Claude Desktop and asks Claude to help with the current task.
Claude calls `get_current_task_context`, proposes actions, asks for confirmation, then invokes allowlisted tools.

### Mode B — Server handoff packet
Server UI generates a Claude handoff prompt containing:
- task summary
- current prompt/result
- problem/rejection reason
- available MCP tools
- requested outcome

Designer pastes the handoff into Claude Desktop. Claude then uses MCP tools.

### Mode C — API Claude delegate
Out of first MVP scope unless an Anthropic API key is configured. This mode may call Claude from the server and connect to remote MCP tools through the API. It must be implemented as an optional provider, not a core dependency.

## MCP tools

### Context tools
```json
{
  "name": "get_current_task_context",
  "input_schema": {"task_id": "string optional"},
  "output_schema": {
    "task_id": "string",
    "workflow_state": "string",
    "brief": "object",
    "latest_prompt": "string optional",
    "latest_artifacts": "array",
    "available_actions": "array"
  }
}
```

### Review tools
- `review_generation_result`
- `propose_prompt_repair`
- `submit_review_note`

### Browser tools
- `browser.list_registered_flows`
- `browser.request_flow_job`
- `browser.get_flow_status`

Claude may request browser-flow jobs through the worker/server protocol, but it must not drive Playwright directly.

### Photoshop tools
- `photoshop.get_document_context`
- `photoshop.request_crop_canvas`
- `photoshop.request_resize_canvas`
- `photoshop.request_export_active_document`

### After Effects tools
- `aftereffects.get_project_context`
- `aftereffects.request_import_assets`
- `aftereffects.request_create_comp_from_preset`
- `aftereffects.request_place_asset_on_timeline`
- `aftereffects.request_add_to_render_queue`

## Safety policy

Claude tools must enforce:
- action allowlist
- typed schemas
- dry-run preview for DCC actions where possible
- explicit confirmation for destructive or export-overwrite actions
- no arbitrary code execution
- no raw JavaScript/ExtendScript/UXP execution in MVP
- no direct database writes

## Task ownership rules

Claude can create `requested_action` records or submit review notes through server-approved endpoints.
Server decides whether to enqueue a job.
Worker executes only server-issued jobs.

## First implementation scope

Implement only:
- MCP server skeleton
- `get_current_task_context`
- `list_available_actions`
- `submit_review_note`
- Photoshop/AE request tools as typed job-creation requests, not direct execution

Do not block first browser E2E on Claude.
