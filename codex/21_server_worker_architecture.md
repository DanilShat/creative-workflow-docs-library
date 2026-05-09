# Server/Worker Architecture

## Architecture decision
Use a two-machine architecture.

### Control plane (owner laptop)
Hosts:
- FastAPI backend
- LangGraph orchestration
- local LLM runtime
- PostgreSQL metadata store
- central artifact registry

### Execution plane (designer laptop)
Hosts:
- worker service
- Playwright browser execution
- Photoshop companion bridge
- After Effects bridge
- temp workspace for refs/downloads/uploads

## Core principle
The server owns state and decision logic.
The worker owns execution against real browsers and real host apps.

## Non-goal
Do not run Photoshop, After Effects or browser sessions on the server machine.

## Scheduling model
- single active worker for MVP
- single active job on worker for MVP
- server dispatches jobs based on required capability
- worker pulls jobs instead of server pushing them

## LLM placement
Local LLM is server-only.
The worker must never call the local LLM directly.

## Required capabilities
- browser.playwright
- browser.gemini
- browser.freepik
- browser.kling
- dcc.photoshop
- dcc.aftereffects

## Success criterion
An end-to-end task can be created on server, executed on worker, returned to server, reviewed, retried and finalized with real artifacts and no mocks.
