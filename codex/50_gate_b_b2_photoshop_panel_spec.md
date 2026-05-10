# Gate B2 — Photoshop Panel Spec

**Status:** B2.2 gateway routing shipped 2026-05-10; Photoshop execution still needs real-app validation.
**Owner:** the creative-workflow project.
**Audience:** Codex/Claude Code agents picking up B2.2 / B2.3, plus the human reviewer.

## Purpose

Give a designer mid-edit in Photoshop a chat panel, *inside Photoshop*, where they can ask for small tweaks ("crop tighter on the right", "darken the sky a touch"). The panel talks to a local agent gateway. The gateway routes the request to the local Ollama LLM first; only if the local model marks the request as ambiguous or creatively heavy does the gateway escalate to Claude. The gateway returns either a free-text reply or a typed action; the panel renders the reply and (in B2.2+) executes the action via UXP APIs on the active document.

This is one of two complementary surfaces for designer-side work:

- **Claude Desktop chat** — briefing room. Big-picture work: kick off campaigns, fan out variants, approve or reject runs. Lives outside any host app.
- **Photoshop UXP panel (this spec)** — workbench assistant. Small in-flow tweaks while editing.

The PS panel never touches the operator API directly. The gateway is the only thing on the designer laptop that holds tokens or talks to the operator.

## Architecture

See `docs/diagrams/gate_b2_architecture.svg` (regenerate from `gate_b2_architecture.graphify.md`).

```
Photoshop on the designer laptop
┌─────────────────────────────────────────────────────────────┐
│  Photoshop                                                   │
│   ┌─ UXP Panel (Creative Workflow Assistant) ──────────┐    │
│   │ chat input  →  fetch http://localhost:8765/chat    │    │
│   │ chat log    ←  ChatResponse {kind, text, action}   │    │
│   └────────────────────────────────────────────────────┘    │
└─────────────────┬───────────────────────────────────────────┘
                  │ localhost
                  ▼
┌─────────────────────────────────────────────────────────────┐
│  Agent Gateway  (FastAPI, 127.0.0.1:8765)                   │
│   POST /chat       — route message, return reply + action   │
│   GET  /health     — panel uses this for the status pill    │
│                                                              │
│   Routing (B2.2):                                           │
│     1. Send to Ollama with a structured-action prompt       │
│     2. If Ollama returns valid action → return it           │
│     3. If Ollama returns "needs claude" → escalate          │
│     4. Claude returns final action or free-text             │
└──────┬─────────────────────────────────┬────────────────────┘
       │                                  │
       ▼                                  ▼
┌──────────────────┐            ┌──────────────────────────┐
│  Ollama (local)  │            │  Claude API (cloud,      │
│  ~7-13B model    │            │  only on escalation)     │
│  no internet     │            │                          │
└──────────────────┘            └──────────────────────────┘
```

## File map

```
creative_workflow_worker/
  dcc/
    photoshop_uxp_plugin/                # the UXP plugin (HTML/JS)
      manifest.json                       # ✅ B2.1
      index.html                          # ✅ B2.1
      panel.css                           # ✅ B2.1
      panel.js                            # ✅ B2.1 (calls gateway, renders log)
      icons/                              # ⏳ B2.3 (real PNGs needed)
      README.md                           # ✅ B2.1

  src/creative_workflow/worker/agent_gateway/
    __init__.py                           # ✅ B2.1
    server.py                             # ✅ B2.1 (FastAPI app + run())
    schemas.py                            # ✅ B2.1 (ChatRequest/Response, Action)
    router.py                             # ✅ B2.2 Ollama-first routing, Claude fallback
    llm/
      __init__.py                         # ⏳ B2.2
      ollama_client.py                    # ⏳ B2.2
      claude_client.py                    # ⏳ B2.2
      prompts.py                          # ⏳ B2.2 (structured-action prompt)
    actions/
      __init__.py                         # ⏳ B2.2
      registry.py                         # ⏳ B2.2 (allowlist + validators)
      handlers.py                         # ⏳ B2.2 (server-side validation only)

  scripts/
    start_agent_gateway.ps1               # ✅ B2.1

  tests/integration/
    test_agent_gateway.py                 # ✅ B2.1 (3 tests, ASGI in-process)
```

Console-script entry point added to `pyproject.toml`:
`creative-workflow-gateway = "creative_workflow.worker.agent_gateway.server:run"`.

## Contracts

### Panel → Gateway

`POST /chat` with body:

```json
{
  "message": "crop tighter on the right",
  "context": {
    "document_name": "hero.psd",
    "document_width": 1080,
    "document_height": 1080,
    "active_layer": "Hero/Product",
    "selection_bounds": null
  }
}
```

`message` is required. `context` is optional but the panel always sends what it can read from `app.activeDocument` via UXP APIs.

### Gateway → Panel

```json
{
  "kind": "action",
  "text": "Cropping right side by 5%.",
  "action": {
    "type": "crop",
    "params": {"side": "right", "percent": 5}
  },
  "routed_to": "ollama"
}
```

Or, when no action is appropriate:

```json
{
  "kind": "message",
  "text": "Tell me which layer you want me to crop.",
  "action": null,
  "routed_to": "ollama"
}
```

`routed_to` is one of `ollama`, `claude`, `rejected` — surfaced for transparency, telemetry, and so the panel can show a small badge ("answered locally" vs "asked Claude").

### Action allowlist (B2.2 lands these)

| `type` | params | UXP call |
|---|---|---|
| `get_context` | `{}` | reads `app.activeDocument` and selection; returns echoed state |
| `crop` | `{side: "left"\|"right"\|"top"\|"bottom", percent: 1..50}` | `app.activeDocument.crop(...)` |
| `export` | `{format: "png"\|"jpg"\|"webp", target_path?: str}` | `document.saveAs.exportAs(...)` |
| `noop` | `{echo?: str}` | nothing — used when the correct answer is only a message |

Anything outside this list is rejected gateway-side (validation in `actions/registry.py`).

## What B2.2 ships

- ✅ UXP plugin loads in Photoshop 24+ via UXP Developer Tool (Develop mode).
- ✅ Panel renders header, status pill, document-context strip, log, composer.
- ✅ Panel hits `GET /health` on load and every 30s; status pill reflects state.
- ✅ Panel posts to `POST /chat` on submit; renders `text` and the action envelope as a green code-pill.
- ✅ Gateway runs via `creative-workflow-gateway` console-script or `scripts/start_agent_gateway.ps1`.
- ✅ Gateway `/chat` routes through Ollama first, escalates to Claude when needed, and rejects off-allowlist actions.
- ✅ Integration tests cover Ollama success, Claude escalation, unavailable-model fallback, and action rejection.
- ✅ Designer-facing setup doc at `designer_workspace/photoshop_panel_setup.md`.

## What still needs hardening

1. **Real Photoshop validation** — load the panel in Photoshop, execute one harmless typed action, and capture the failure path when Photoshop is unavailable.
2. **Panel-side action execution** — `panel.js` currently displays validated actions; the next hardening pass should execute the matching UXP call for the allowlisted action types.
3. **Action result callback** — add a gateway endpoint such as `POST /chat/result` if the worker needs a durable record of panel-side execution.
4. **Packaging** — package the panel as a `.ccx` so designers do not need UXP Developer Tool for day-to-day use.

## What B2.3 must add (after B2.2)

- **Plugin packaging** — generate `.ccx` artifact via Adobe's UXP packager so designers don't need UXP Developer Tool.
- **Real plugin icons** at `dcc/photoshop_uxp_plugin/icons/icon-light.png` and `icon-dark.png` (23×23 @ 1× and @ 2×).
- **Streaming responses** — `POST /chat` returns a `text/event-stream` so the panel can show partial text as Claude streams.
- **Telemetry hook** — count routed_to=ollama vs routed_to=claude vs rejections; surface in the operator dashboard.
- **Operator-side audit log** — gateway should write each (message, action, routed_to) to a local JSONL file the operator can ingest.

## Locked decisions (resolved 2026-05-10)

1. **Action execution lives in the worker, not the panel.** The worker owns a single `dcc/photoshop_actions.py` library that defines crop/export/get_context. Two consumers use it: (a) the panel, which receives a typed, validated action from the gateway and executes it via UXP APIs (the panel is a thin executor — it only translates the worker's typed action into the matching UXP call); (b) the batch path, where the worker spawns headless Photoshop scripts (JSX/UXP CLI) for jobs kicked off from Claude Desktop chat. *Why:* one source of truth, no duplicated crop logic between interactive and batch flows. *Cost:* the panel has to stay generic — every new action requires a worker-side definition first, then a panel dispatcher entry. Worth it.

2. **Claude escalation: Sonnet by default, Opus for creative.** The local model marks each escalation request with a `complexity` hint (`mechanical | creative`) in its envelope; the gateway uses this to pick the model. Mechanical defaults to `claude-sonnet-4-20250514`. Creative defaults to `claude-opus-4-1-20250805`. Designers can override these with `CLAUDE_SONNET_MODEL` and `CLAUDE_OPUS_MODEL`.

3. **Local model: `gemma3n:e2b`** — same model the operator already runs for brief planning. Ollama at `http://127.0.0.1:11434`. Reuse `OLLAMA_MODEL` and `OLLAMA_BASE_URL` env var names so designer laptop config mirrors the operator's. Document a 16 GB RAM floor; gemma3n:e2b is ~2 GB resident so this is comfortable.

4. **Network permissions: tight.** Manifest stays at `localhost:8765` + `127.0.0.1:8765`. The gateway is the only thing on the designer laptop that holds tokens or reaches the internet — letting the panel reach further dilutes that. If a future feature needs the panel to call something else, the right move is to add a gateway endpoint that proxies it, not to widen the manifest.

## Implications these decisions have on B2.2 (read before coding)

Decision 1 changes the panel's role. The original sketch had `panel.js` containing a switch on action type and calling `app.activeDocument.crop(...)` directly. With decision 1, the panel becomes a **dispatcher** that takes a typed action object — already validated by the worker — and runs the matching UXP call. The "what is a valid crop, what params are valid, what UXP call expresses it" lives in worker Python code under `creative_workflow/worker/dcc/photoshop_actions.py`.

Concretely, B2.2 now needs:

```
creative_workflow_worker/
  src/creative_workflow/worker/
    dcc/
      photoshop_actions.py        # NEW — owns the action library
        # def get_context() -> ActionDescriptor
        # def crop(side, percent) -> ActionDescriptor
        # def export(format, target_path) -> ActionDescriptor
        # ActionDescriptor = pydantic model with: type, params, uxp_call_template
    agent_gateway/
      actions/
        registry.py               # imports photoshop_actions, builds the allowlist
        validators.py             # param-range checks
  dcc/photoshop_uxp_plugin/
    panel.js                      # add: dispatcher that maps ActionDescriptor.uxp_call_template to UXP calls
```

The `ActionDescriptor` shape is what the panel actually executes:

```python
class ActionDescriptor(BaseModel):
    type: Literal["crop", "export", "get_context", "noop"]
    params: dict[str, Any]
    # UXP call instructions. Panel reads `method` and calls
    # app.activeDocument[method](**params_as_kwargs). Keeps panel.js
    # generic — no per-action JS branches.
    uxp_call: dict[str, Any]
```

Decision 2 makes the gateway router two-stage: parse → ask Ollama → if `needs_claude` then route to Sonnet OR Opus based on Ollama's `complexity` hint. The Ollama prompt template (`agent_gateway/llm/prompts.py`) must teach the model to emit both `needs_claude` and `complexity`.

Decision 3 means `agent_gateway/llm/ollama_client.py` reuses the operator's existing `OLLAMA_BASE_URL` / `OLLAMA_MODEL` env vars and points at `gemma3n:e2b` by default. If you want the designer laptop to use a different model from the operator (e.g. designer wants a beefier model), it's just a different `OLLAMA_MODEL` value in `.env.worker` — no code change.

Decision 4 means **don't** add CORS origins or manifest domains for any cloud service. If you need to talk to Anthropic from the panel, route it through the gateway. The panel's network surface stays at one host, one port.

## How to validate manually

```powershell
# Start the gateway
cd <creative-workflow-worker-repo-root>
python -m pip install -e ".[test]"
.\scripts\start_agent_gateway.ps1

# In another shell, verify it's up
curl http://127.0.0.1:8765/health

# Load the plugin in Photoshop via UXP Developer Tool, open the panel,
# type "test" and send. The panel should display:
#   - Your "test" message in blue (right-aligned)
#   - The gateway's agent reply in grey (left-aligned)
#   - A routed_to badge showing ollama, claude, or rejected
```

## Tests

Worker integration tests now cover both layers:

```
tests/integration/test_mcp_tools.py        — MCP tools for Claude Desktop
tests/integration/test_agent_gateway.py    — panel/gateway routing and rejection paths
tests/integration/test_worker_lifecycle.py — 1 passing (existing)
```

Operator service+unit tests: 16 passing.
