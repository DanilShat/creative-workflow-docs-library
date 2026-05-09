# Server/Worker Acceptance Suite

## Purpose
Define checks proving the system is real and not mock-driven.

## Gate A — First real vertical slice: browser E2E
Gate A is the first MVP definition of done. It must pass without Photoshop/After Effects.

### Test A1: worker registration and auth
- Start server on operator laptop.
- Start worker on designer laptop.
- Worker registers with valid bearer token.
- Worker heartbeat is visible in server UI or DB.
- Invalid/revoked token is rejected.

### Test A2: browser profile setup/status
- Run `worker profile setup gemini` in headed mode.
- Designer logs in manually if needed.
- Run `worker profile status gemini` and confirm `authenticated`.
- Repeat for `freepik`.

### Test A3: Gemini browser prompt-builder flow
- Create task in server UI with one reference image.
- Server stores reference file and metadata.
- Server produces a Gemini browser-flow job.
- Worker claims job and runs real headed/persistent Playwright flow.
- Worker returns structured prompt output and debug artifacts.
- Server records job completed and prompt history.

### Test A4: Freepik browser generation flow
- Server creates Freepik image-generation job using the Gemini prompt.
- Worker claims job and runs real Freepik browser flow.
- Worker downloads a real generated file.
- Worker uploads generated artifact plus debug artifacts.
- Server stores asset metadata and file path.
- Workflow moves to `waiting_human_review` on server.
- Worker returns to idle.

### Test A5: reject/retry workflow
- Operator rejects result in UI with reason.
- Server records feedback.
- Server creates a new repair/retry job.
- Previous attempt remains visible in history.

### Gate A evidence
A passing Gate A requires:
- server logs;
- worker logs;
- DB rows for task, jobs, runs, prompts, assets, reviews;
- downloaded generated file under artifact root;
- debug screenshots/traces for Gemini and Freepik;
- worker idle after artifact upload and before human review.

## Gate B — DCC integration acceptance
Gate B comes after Gate A. It must not be faked to claim first MVP completion.

### Test B1: Photoshop host action
- Worker reports Photoshop capability.
- Server creates typed `photoshop_action` job.
- Worker executes allowlisted host action through bridge/panel.
- Modified/exported file is uploaded back.

### Test B2: After Effects host action
- Worker reports After Effects capability.
- Server creates typed `aftereffects_action` job.
- Worker executes allowlisted bridge action.
- Result/debug status is uploaded back.

## Gate C — Reliability acceptance
- Kill worker during running job.
- Server marks worker offline after stale threshold.
- Job becomes orphaned or recoverable according to policy.
- Uploaded artifact is retrievable by asset id.
- Task/job/run linkage is preserved.

## Definition of done
- First browser MVP is accepted when Gate A passes without mocks.
- DCC milestone is accepted only when Gate B passes with real local Photoshop/AE execution.
- Mocked tests can support unit/contract coverage but must not be called live-browser or live-DCC coverage.
