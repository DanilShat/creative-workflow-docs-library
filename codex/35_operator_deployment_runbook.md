# Operator Deployment Runbook

## Goal
Run a real two-laptop MVP: server on operator laptop, worker/browser execution on designer laptop.

## Required scripts/commands
Implementation must provide commands equivalent to:

### Server
```bash
server config check
server db migrate
server dev
server worker-token create --worker-id designer-laptop-01
server worker-token revoke --worker-id designer-laptop-01
server healthcheck
server cleanup dry-run
server cleanup apply
```

### Worker
```bash
worker config check
worker run
worker healthcheck
worker profile setup gemini
worker profile setup freepik
worker profile status
worker profiles list
```

Each command must print clear success/failure output.

## Operator laptop setup
1. Install Python env.
2. Install PostgreSQL or start local Postgres.
3. Install Ollama or compatible local LLM runtime.
4. Pull/configure chosen small orchestration model.
5. Configure server `.env`.
6. Run `server config check`.
7. Run `server db migrate`.
8. Run `server worker-token create --worker-id designer-laptop-01`.
9. Start server with `server dev`.
10. Confirm `server healthcheck` passes.

## Designer laptop setup
1. Install Python env.
2. Install Playwright browsers.
3. Configure worker `.env` with server URL, worker id and token.
4. Run `worker config check`.
5. Run `worker profile setup gemini` and login manually.
6. Run `worker profile setup freepik` and login manually.
7. Run `worker profile status` until both are `authenticated`.
8. Start worker with `worker run`.
9. Confirm worker appears online in server UI.

## Firewall/LAN notes
- Operator server port must be reachable from designer laptop.
- Ollama port must not be exposed to LAN.
- Use LAN/private VPN only for MVP.

## First live browser validation evidence
A pass must include:
- task visible in UI;
- worker online heartbeat;
- Gemini debug screenshot/trace;
- Gemini structured prompt output saved;
- Freepik generated file downloaded and uploaded;
- asset row with checksum and path;
- job/run history visible;
- workflow enters `waiting_human_review`;
- worker returns to idle;
- reject creates a new repair/retry job.

## Do not accept as MVP
- fake generated image fixtures instead of Freepik output;
- mocked Gemini/Freepik in live acceptance;
- Photoshop/AE fake completion as first MVP proof;
- server calls Ollama through public LAN URL;
- worker stuck leased during human review.
