# Host Action Protocol

> CURRENT OVERRIDE: Server owns planning, orchestration, state and local LLM access. Designer-side worker/host bridges execute typed allowlisted actions only. Panels may expose local context and ask for approval, but they do not own authoritative workflow state and must not call an LLM directly for authoritative planning. DCC live execution is post-Gate-A, after the Gemini + Freepik browser E2E slice.

## Objective
Define the internal protocol between the server-owned planner/state layer and designer-side host bridges (Photoshop panel, After Effects bridge).

## Design goals
- typed actions only
- deterministic execution
- no arbitrary code execution as default path
- preview before run
- reusable across hosts

## Core models
```python
from typing import Literal, Any
from pydantic import BaseModel, Field

class HostAction(BaseModel):
    host: Literal["photoshop", "after_effects"]
    action_name: str
    args: dict[str, Any] = Field(default_factory=dict)
    dry_run: bool = False
    requires_confirmation: bool = False
    request_id: str
    task_id: str | None = None
    scene_id: str | None = None

class HostActionPlan(BaseModel):
    plan_id: str
    host: Literal["photoshop", "after_effects"]
    user_intent: str
    actions: list[HostAction]
    summary: str
    warnings: list[str] = Field(default_factory=list)

class HostExecutionResult(BaseModel):
    success: bool
    host: str
    action_name: str
    request_id: str
    outputs: list[dict] = Field(default_factory=list)
    warnings: list[str] = Field(default_factory=list)
    error_message: str | None = None
    debug_artifacts: list[str] = Field(default_factory=list)
```

## Internal endpoints
The server owns planning/state endpoints. Designer-side worker/bridge components expose only local bridge calls needed to execute server-issued allowlisted actions.

Server-owned endpoints:
- `GET /host-actions/catalog`
- `POST /host-actions/plan`
- `GET /host-actions/runs/{request_id}`

Worker-mediated execution endpoint:
- `POST /host-actions/execute`

The execute path must validate that the action came from a server-approved job or plan.

## Planning flow
1. UI or panel sends user intent and host context to the server through the approved server/worker path
2. server returns a `HostActionPlan`
3. panel shows summary + actions
4. user confirms or rejects
5. panel or worker sends execute request for each approved action or for the whole plan
6. worker/bridge executes the typed action
7. server logs results and updates workflow history

## Execution modes
### Dry run
Used to preview which actions will be executed and with which args.

### Confirmed run
Runs actions only after explicit confirmation.

## Safety rules
- reject unknown `action_name`
- validate args using per-action schemas
- mark destructive actions with `requires_confirmation=True`
- do not accept raw script text as the primary execution payload
- execution logs must persist to DB

## Per-action schema registry
Implement a registry:
```python
ACTION_SCHEMAS = {
    ("photoshop", "crop_canvas"): CropCanvasArgs,
    ("photoshop", "export_active_document"): ExportActiveDocumentArgs,
    ("after_effects", "create_comp_from_preset"): CreateCompArgs,
}
```

## Host bridge contract
Each bridge must expose:
- `get_context()`
- `execute_action(action: HostAction) -> HostExecutionResult`
- `ping()`

## Logging requirements
Persist:
- request_id
- task_id
- scene_id
- host
- action_name
- args snapshot
- dry_run flag
- start/end timestamp
- success/failure
- outputs
- warnings
- error_message
