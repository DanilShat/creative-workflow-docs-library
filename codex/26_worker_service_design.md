# Worker Service Design

## Goal
Implement a real execution service on the designer laptop that can run browser flows and DCC host actions without mocks.

## Process model
Use one OS process for MVP with internal modules:
- coordinator
- polling client
- browser executor
- photoshop executor
- aftereffects executor
- asset manager
- telemetry manager

## Concurrency model
Exactly one active job at a time.
This is mandatory in MVP to avoid conflicts in:
- browser profiles
- Photoshop state
- After Effects project state
- temp workspace management

## Internal modules
### coordinator
Owns worker state machine and dispatches jobs to executors.

### polling client
Handles register, heartbeat, claim-next, progress, completion and retries.

### browser executor
Runs registered Playwright flows by flow name.
Reject unknown flow names.

### photoshop executor
Calls only allowlisted host actions through the local Photoshop companion bridge.
Reject raw code execution.

### aftereffects executor
Calls only allowlisted host actions through the local AE bridge.
Reject raw code execution.

### asset manager
Downloads input refs from server, prepares local paths, uploads outputs, cleans temp files.

### telemetry manager
Creates step logs, screenshots, traces and structured error records.

## Worker local state
Persist a small local state file containing:
- worker_id
- token
- server_url
- current status
- current active job id
- installed capability snapshot
- local temp workspace root

## Startup checks
On startup the worker must verify:
- server reachability
- local workspace path exists
- Playwright available
- required browser profiles directory exists
- Photoshop bridge connectivity if Photoshop capability enabled
- After Effects bridge connectivity if AE capability enabled

## Shutdown behavior
On graceful stop:
- stop claiming new jobs
- if active job exists, send best-effort fail or handoff state
- flush logs
- release local locks
