Proceed to implementation.

Build the real MVP end-to-end in this repository according to the specs you already read.

## Current implementation target
The first implementation target is **Gate A: browser-first vertical slice**.

Do not make Photoshop/After Effects live execution a blocker for the first MVP unless I explicitly request it in this chat. DCC contracts and bridge skeletons may exist, but they must not be faked to satisfy MVP completion.

## Required Gate A path
- server on operator laptop
- worker on designer laptop
- worker token auth
- registration, heartbeat, job claiming
- file upload/download
- local LLM orchestration with strict JSON outputs
- Playwright persistent profiles
- Gemini browser prompt-builder flow
- Freepik browser generation/download flow
- artifact upload and history
- server-side human approve/reject workflow
- reject creates new repair/retry job

## Execution requirements
- Do not create placeholder architecture without working paths.
- Do not replace real components with mocks unless explicitly required only for isolated tests.
- Implement the actual server/worker architecture.
- Implement the local orchestrator path with an Ollama-compatible local LLM client.
- Implement the worker with HTTP polling, heartbeat, job claiming, artifact upload, and status reporting.
- Implement browser automation as real Playwright-based modules with allowlisted flows and proper runtime abstractions.
- Implement DCC and Claude contracts as post-Gate-A surfaces if time allows, but do not claim them live unless they work on real software.
- Implement database models, migrations, storage layout, retention hooks, and operator scripts.
- Implement meaningful tests that cover contracts, worker lifecycle, job state transitions, file transfer behavior, and failure handling.
- Add clear comments that explain each functional component, why it exists, and how it fits the system.
- Keep the codebase clean and production-minded.
- When making assumptions, document them in code and docs.
- Keep going until Gate A can realistically run from the provided runbook.

At the end, provide:
1. what was implemented,
2. which gate is now runnable,
3. what still requires local credentials/accounts/software on the operator/designer side,
4. exact commands to run server and worker,
5. exact commands to run tests,
6. exact first-run setup steps,
7. exact live-browser validation checklist.
