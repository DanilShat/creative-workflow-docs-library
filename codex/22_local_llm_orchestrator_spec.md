# Local LLM Orchestrator Spec

## Role
The local LLM on the operator laptop is the cheap default orchestration brain. It does not execute browsers, Photoshop or After Effects.

It produces strict JSON for:
- brief normalization
- job type classification
- route decision
- repair/retry decision
- human-review summarization

## Deployment
- Ollama-compatible endpoint on operator laptop.
- Bound to localhost only: `http://127.0.0.1:11434`.
- Server calls local LLM; worker never calls Ollama directly.

## Required schemas

### Brief normalization
See `codex/27_job_schema_and_state_machine.md`.

### Route decision
See `codex/27_job_schema_and_state_machine.md`.

### Retry/repair decision
See `codex/27_job_schema_and_state_machine.md`.

## JSON parser policy
- Request JSON-only outputs.
- Validate with Pydantic or equivalent.
- On invalid JSON: retry once with repair instruction.
- If still invalid: fall back to deterministic rules or human clarification.

## Not allowed
- no direct browser execution
- no direct DB mutation outside server service layer
- no long multimodal video analysis as a required MVP path
- no arbitrary host code generation for Photoshop/AE

## Premium fallback
Gemini browser and optional Claude Desktop/MCP may be used as external reasoning helpers, but the core Gate A path must be runnable with local LLM orchestration plus browser flows.
