# Claude Code Collaboration Manifest

## Purpose

This manifest is the shared starting point for Codex, Claude Code, and the
human operator when designing the next Creative Workflow gates.

The next system layer adds local agent sidecars as optional desktop/browser/DCC
helpers:

- Ollama handles routine local reasoning.
- Claude Code CLI and Codex CLI can help reason about creative tasks through
  subscription accounts logged in on the designer laptop.
- Claude Code CLI and Codex CLI can operate already trusted visible browser
  sessions when Playwright login is blocked by provider security checks.
- Local agents can request typed Photoshop and After Effects actions.
- Local agents must not become the authoritative state owner.

## Three repos

- `creative_workflow_docs_library` is the canonical specification library.
- `creative_workflow_operator` owns server state, Streamlit UI, queue,
  local LLM orchestration, artifacts, worker auth, and review workflow.
- `creative_workflow_worker` runs on designer laptops and executes browser/DCC
  jobs through allowlisted local capabilities.

```text
Operator laptop <--> Designer worker laptop <--> Ollama / Claude Code CLI / Codex CLI
```

## Core design decision

Local agents are an enhancement layer, not a replacement for the server/worker
protocol.

The operator server remains the source of truth for:

- tasks
- runs
- jobs
- assets
- reviews
- retry state
- worker authentication

The designer worker remains the execution boundary for:

- artifact downloads/uploads
- status and heartbeat
- browser/DCC capability reporting
- local bridge access

Ollama, Claude Code, and Codex can propose, inspect, and request work. They
must not directly mutate database state, bypass worker auth, or execute
arbitrary host-app code.

## Integration modes

### Mode 1 - Agent chat job

The Streamlit UI creates a `designer_agent_chat` worker job. The worker routes
routine requests to Ollama and escalates browser/creative requests to the
least-used available Claude Code CLI or Codex CLI account.

The job contains:

- task id
- designer message
- preferred agent, when the designer forces one
- small task context packet
- durable job/run ids for audit

The worker returns the reply through normal job completion. This path uses
subscription CLI logins on the designer laptop, not Anthropic/OpenAI API keys.

### Mode 2 - Local Claude MCP sidecar

Claude Desktop connects to a local MCP server on the designer laptop.

```text
Claude Desktop
  -> local MCP server
  -> designer worker API/tools
  -> operator FastAPI
  -> PostgreSQL/artifacts/job queue
```

Minimum MCP tools:

- `get_current_task_context`
- `list_available_actions`
- `submit_review_note`
- `request_browser_assisted_job`
- `request_photoshop_action_job`
- `request_aftereffects_action_job`

MCP tools create typed requests or server jobs; they do not directly write the
database.

### Mode 3 - Claude-assisted visible browser

Use this when Playwright cannot log in because the provider treats it as a new
device.

Claude may operate a visible browser session that the designer is already
logged into, under designer supervision. This is not cookie cloning and not an
auth bypass. The designer remains responsible for approving account access and
visible UI actions.

Allowed browser tasks:

- open a provider page
- read visible state
- fill a prompt field
- click explicit UI controls
- wait for generation
- download/export visible outputs
- hand downloaded files back to the worker upload path

Disallowed browser tasks:

- bypass login or provider security checks
- extract cookies or session tokens
- run hidden browser automation against user accounts
- click purchase, billing, or account controls without explicit human
  confirmation

### Mode 4 - Photoshop action bridge

Photoshop should use a narrow UXP/local bridge.

Claude may request only typed actions such as:

- get active document context
- open/import an asset
- crop canvas
- resize canvas
- place image layer
- export active document

Claude must not send arbitrary UXP JavaScript. The Photoshop bridge maps typed
actions to reviewed implementation code.

### Mode 5 - After Effects action bridge

After Effects should start with a conservative script/bridge surface.

Claude may request only typed actions such as:

- get project context
- import footage
- create comp from preset
- place asset on timeline
- set basic transform/keyframe values
- add comp to render queue

Claude must not send arbitrary ExtendScript. The After Effects bridge maps
typed actions to reviewed implementation code.

## Safety boundaries

Every Claude-facing tool must enforce:

- typed schemas
- action allowlists
- idempotency keys where jobs are created
- dry-run/preview where possible
- explicit human confirmation for destructive/export-overwrite actions
- artifact upload through the worker/server path
- no direct database writes
- no arbitrary generated Photoshop/After Effects code execution
- no credential, cookie, token, or browser-profile extraction

## Implementation sequence

1. Add server endpoints that produce Claude handoff packets from task history.
2. Add a local MCP server skeleton in the worker repo.
3. Add read-only tools: current task context and available actions.
4. Add review-note and repair-plan tools.
5. Add browser-assisted request jobs for visible browser operation.
6. Add Photoshop typed action request jobs.
7. Add After Effects typed action request jobs.
8. Add worker bridge executors for Photoshop and After Effects.
9. Add UI labels that distinguish Playwright automation from Claude-assisted
   visible browser work.
10. Add acceptance tests for each tool/action family before claiming a gate is
    live.

## Acceptance gates

### Gate B0 - Claude read-only sidecar

- Claude can read current task context through MCP.
- Claude can list actions and submit a review note.
- No browser/DCC execution is claimed.

### Gate B1 - Claude-assisted browser

- Claude can operate the already trusted visible browser under supervision.
- Output files are uploaded through the worker artifact path.
- The operator UI shows the mode as `claude_desktop_browser_assisted`.

### Gate B2 - Photoshop bridge

- A real Photoshop install executes at least one typed action end to end.
- The bridge reports unavailable instead of faking success when Photoshop is not
  connected.

### Gate B3 - After Effects bridge

- A real After Effects install executes at least one typed action end to end.
- The bridge reports unavailable instead of faking success when After Effects is
  not connected.

## Agent collaboration protocol

When Codex or Claude Code changes the plan, update this manifest or the
repo-local `AGENT_MANIFEST.md` before code changes.

Use this handoff format:

```markdown
## Handoff Log

### YYYY-MM-DD - Agent name
- Context:
- Decision:
- Files changed:
- Tests run:
- Open questions:
```

Do not overwrite another agent's handoff entry. Append a new entry.

## Handoff Log

### 2026-05-10 - Codex
- Context: Added the initial Claude/browser/DCC sidecar design manifest.
- Decision: Claude remains optional and must use typed, allowlisted server and
  worker boundaries.
- Files changed: this manifest plus split-repo pointers.
- Tests run: documentation-only change; no tests required.
- Open questions: exact MCP framework/package choice, Photoshop bridge
  transport, and After Effects bridge transport remain implementation
  decisions.

### 2026-05-10 - Claude Code + Codex
- Context: Claude Code implemented most of the Gate B worker surface. Codex
  reviewed the result and fixed the missing B3 MCP tool registration.
- Decision: B0/B1 queue tools and B2 gateway routing are test-covered. B3 is
  wired through `submit_aftereffects_render` to local `aerender.exe`, but it is
  not live-accepted until a real After Effects install renders a sample comp.
- Files changed: worker MCP/gateway/DCC files, designer workspace docs, and
  Gate B spec notes.
- Tests run: worker pytest suite and operator pytest suite.
- Open questions: real Photoshop action execution, Claude-assisted visible
  browser control, and sample AE project validation remain open.

### 2026-05-11 - Codex
- Context: Operator-to-designer SSH access was configured for faster remote
  diagnostics.
- Decision: Use a dedicated SSH key from the operator laptop to the designer
  laptop. Keep it command-line only; GUI/browser/DCC validation remains manual.
- Files changed: `docs/designer_laptop_ssh_handoff_for_claude.md`, this
  manifest.
- Tests run: remote SSH login and worker config check.
- Open questions: Git is not currently available in the designer laptop SSH
  session, so remote `git pull` needs Git for Windows or PATH setup first.

### 2026-05-12 - Codex
- Context: Added local-agent chat as the first mixed operator/worker agent
  path for Ollama, Claude Code CLI, and Codex CLI.
- Decision: Ollama runs on the operator laptop. Codex and Claude are not server
  API integrations here; they are local CLIs logged in on the designer laptop,
  invoked by the worker through `designer_agent_chat` jobs.
- Files changed: split-repo worker/operator code and manifests; this manifest.
- Tests run: targeted operator and worker pytest suites for agent routing,
  API creation, job completion, and worker lifecycle.
- Open questions: live CLI flags and browser-capable Codex behavior still need
  validation after the user installs/logs in to Codex and Claude Code on the
  designer laptop.
