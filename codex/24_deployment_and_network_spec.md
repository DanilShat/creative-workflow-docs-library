# Deployment and Network Spec

## Topology
Operator laptop:
- FastAPI backend/API
- Streamlit UI
- LangGraph runtime
- PostgreSQL
- artifact root
- Ollama-compatible local LLM endpoint bound to localhost only

Designer laptop:
- worker service
- Playwright browser profiles
- Photoshop/After Effects bridges
- optional Claude Desktop + local MCP server

## Network
MVP assumes LAN or private VPN.
Do not expose the server publicly without a separate security review.

The Streamlit UI and worker API are exposed through the operator laptop server URL. `SERVER_PUBLIC_BASE_URL` is the canonical base URL used by the worker and by links shown in the UI.
Ollama remains `127.0.0.1` only on operator laptop.

## Server env
See `runtime_docs/env.example.md`.

Required:
- DATABASE_URL
- SERVER_PUBLIC_BASE_URL
- ARTIFACT_ROOT
- SERVER_SECRET
- ALLOW_WORKER_REGISTRATION
- TRUSTED_WORKER_IDS
- OLLAMA_BASE_URL
- OLLAMA_MODEL

## Worker env
Required:
- SERVER_BASE_URL
- WORKER_ID
- WORKER_TOKEN
- WORKER_TEMP_ROOT
- PLAYWRIGHT_PROFILE_ROOT
- WORKER_CAPABILITIES

## Bootstrap flow
1. Start server locally.
2. Run migrations.
3. Create trusted worker id.
4. Generate worker token.
5. Copy worker token to designer laptop.
6. Start worker.
7. Worker registers and heartbeats.
8. Run profile setup for Gemini/Freepik.
9. Run Gate A E2E.

## Token revocation
Server must support marking a worker token revoked. Revoked token rejects register, heartbeat, claim-next and upload calls.
