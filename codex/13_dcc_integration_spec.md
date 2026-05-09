# DCC Integration Spec

> CURRENT OVERRIDE: Server owns planning, orchestration, state and local LLM access. Designer-side worker/host bridges execute typed allowlisted actions only. Panels may expose local context and ask for approval, but they do not own authoritative workflow state and must not call an LLM directly for authoritative planning. DCC live execution is post-Gate-A, after the Gemini + Freepik browser E2E slice.

## Goal
Add host-application integrations so the local creative workflow system can drive desktop creative tools in a controlled way.

DCC = digital content creation software.

Primary targets:
- Adobe Photoshop
- Adobe After Effects
- CapCut (constraints-first, not assumed extensible)

## Design principle
Do not allow the agent to emit arbitrary host-native code as the primary execution path.

Preferred design:
1. server interprets user intent and owns authoritative planning/state
2. server planner maps intent to typed host actions
3. designer-side worker/host bridge validates action against allowlist
4. host bridge executes action
5. result is logged and returned to the server

## Integration modes
### Mode A — native plugin/panel bridge
Use a plugin/panel inside the host app that communicates with the designer worker or bridge. Planning and authoritative state still belong to the server.

### Mode B — script launcher bridge
Use a local script runner that writes script files and launches them in the host app.

### Mode C — desktop/browser automation fallback
Use automation only when the host app has no stable public extensibility layer.

## Recommended target mapping
- Photoshop -> Mode A
- After Effects -> Mode A or B
- CapCut -> Mode C by default

## Shared architecture
```text
User request
  -> server UI/API
  -> server intent planner
  -> host action plan
  -> designer worker
  -> host-specific bridge or panel
  -> host app execution
  -> execution result + logs
  -> server history and UI
```

## Shared contracts
### HostAction
```python
class HostAction(BaseModel):
    host: Literal["photoshop", "after_effects", "capcut"]
    action_name: str
    args: dict
    dry_run: bool = False
```

### HostExecutionResult
```python
class HostExecutionResult(BaseModel):
    success: bool
    host: str
    action_name: str
    outputs: list[dict] = []
    warnings: list[str] = []
    error_message: str | None = None
    debug_artifacts: list[str] = []
```

## Safety model
- allowlist only
- schema validation for action args
- explicit dry-run support
- user approval for destructive actions
- execution logs persisted in DB
- no arbitrary shell command generation by default

## Core host action API
The server should expose planning/state endpoints and the designer worker or host bridge should expose only execution/bridge calls. These endpoints are post-Gate-A and must preserve the server/worker ownership split:
- `POST /host-actions/plan`
- `POST /host-actions/execute`
- `GET /host-actions/catalog`
- `GET /host-actions/runs/{id}`

The planner endpoint is server-owned. The execute path is worker-mediated and may call a local Photoshop/AE bridge, but the bridge must not call an LLM directly or create authoritative workflow state.

## First milestone
Implement only a narrow action catalog:
- Photoshop crop/resize/export/open file
- After Effects import footage/create comp/place layer/render queue add
- CapCut none initially
