# Worker Protocol Spec

## MVP transport
Use HTTP + polling. Do not require WebSocket for worker execution in MVP.

## Timing defaults
- heartbeat interval: 15s
- idle claim-next polling interval: 3s
- active job lease TTL: 90s
- stale worker threshold: 45s without heartbeat
- default browser image job hard timeout: 20m

## Worker lifecycle
1. boot
2. load config/env
3. register
4. start heartbeat loop
5. start idle polling loop
6. claim compatible job
7. download input assets
8. execute browser/host action
9. upload artifacts
10. complete or fail job
11. return to idle

## Single-job invariant
MVP worker processes exactly one active job at a time.

## Auth/bootstrap
See `codex/39_reviewer_blocker_fixes_applied.md` and `codex/25_api_and_ws_surface.md`.

## Job states
Worker job states:
- queued
- claimed
- running
- uploading_artifacts
- completed
- failed_retryable
- failed_fatal
- cancelled
- orphaned

`waiting_human` is not a worker job state.
Human review belongs to server workflow state after job completion.

## Server workflow states related to jobs
- waiting_worker
- running_worker_job
- waiting_human_review
- accepted
- rejected_creates_retry
- failed

## Claim-next rules
- only claim jobs matching worker capabilities
- only claim jobs when worker has zero active jobs
- claim response includes lease expiration and job timeout
- server records `claimed_by_worker_id` and `claimed_at`

## Lease renewal
- lease is renewed by heartbeat while running a job
- if lease expires, server marks job orphaned
- orphaned jobs may be requeued only if job type is retryable and idempotent enough

## Completion rules
Worker completes a job only after:
- all required structured outputs are present
- all declared artifacts are uploaded or explicitly unavailable
- final status is written once
- worker local temp cleanup is safe

After job completion the worker returns to idle even if the server workflow waits for human review.

## Failure classes
Use the canonical enum from `codex/29_reliability_and_failure_policy.md`:
- needs_reauth
- dependency_unavailable
- selector_broken
- upload_failed
- download_failed
- network_temporary
- provider_quota_or_paywall
- browser_profile_broken
- transient_browser_start_failure
- photoshop_not_connected
- aftereffects_not_connected
- invalid_job_payload
- unsupported_action_name
- fatal_unexpected

## Required commands
- `worker run`
- `worker healthcheck`
- `worker profile setup <service>`
- `worker profile status [service]`
- `worker profiles list`
- `worker config check`
