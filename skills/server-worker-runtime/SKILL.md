---
name: server-worker-runtime
description: Use when implementing server-worker communication, worker lifecycle, job polling, heartbeats, leases, job state transitions, artifact upload, or two-machine deployment.
---

# Server/Worker Runtime Skill

## Use when

Use this skill for:

- FastAPI worker endpoints;
- worker registration;
- heartbeat;
- claim-next polling;
- job leases;
- job status transitions;
- artifact upload/download;
- worker tokens;
- local network deployment.

## Architecture invariant

The server owns state. The worker owns execution.

The worker must not:

- call the local LLM directly;
- create authoritative task state;
- bypass server job state machine;
- run multiple active jobs in MVP.

## Transport defaults

- HTTP + polling.
- heartbeat every 15 seconds.
- idle claim polling every 3 seconds.
- active job lease TTL 90 seconds.
- one active job per worker.
- worker authenticates with `WORKER_TOKEN`.

## Required job lifecycle

Server-side states:

- `queued`
- `claimed`
- `running`
- `uploading_artifacts`
- `completed`
- `failed_retryable`
- `failed_fatal`
- `cancelled`
- `orphaned`

Server workflow states after job completion:

- `waiting_human_review`
- `human_approved`
- `human_rejected`
- `retry_requested`

`waiting_human_review` is not an active worker job state. The worker returns to `idle` after completion and artifact upload.

Worker runtime states:

- `starting`
- `registering`
- `idle`
- `claiming`
- `preparing_inputs`
- `running`
- `uploading_outputs`
- `error`
- `stopping`

## Lease policy

- Heartbeat renews lease while job is active.
- Expired lease marks job `orphaned`.
- Orphaned jobs requeue only if retryable.
- Terminal states are final.

## Artifact protocol

- Server stores metadata in DB.
- Files live on disk.
- Worker uploads outputs before completion.
- Completion without declared artifacts is invalid unless artifacts are explicitly marked unavailable.

## Source inspiration

Adapted for this project from context/tool-design patterns in `Agent-Skills-for-Context-Engineering` and production runtime quality patterns from `addyosmani/agent-skills`.
