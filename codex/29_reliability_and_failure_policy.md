# Reliability and Failure Policy

## Goal
The system must be able to run as a real MVP, not as a mocked demonstration.

## Failure classes
Use this canonical enum everywhere the server or worker records a failed job:
- `needs_reauth`
- `dependency_unavailable`
- `selector_broken`
- `upload_failed`
- `download_failed`
- `network_temporary`
- `provider_quota_or_paywall`
- `browser_profile_broken`
- `transient_browser_start_failure`
- `photoshop_not_connected`
- `aftereffects_not_connected`
- `invalid_job_payload`
- `unsupported_action_name`
- `fatal_unexpected`

## Retry policy
Default retryability:
- retryable up to policy limit: `network_temporary`, `upload_failed`, `download_failed`, `transient_browser_start_failure`
- operator-fixable without blind retry: `needs_reauth`, `dependency_unavailable`, `provider_quota_or_paywall`, `browser_profile_broken`, `photoshop_not_connected`, `aftereffects_not_connected`
- fatal unless explicitly overridden by operator: `selector_broken`, `invalid_job_payload`, `unsupported_action_name`, `fatal_unexpected`

Browser/network transient failures default to 2 attempts. Host app connection failures are marked operator-fixable. `selector_broken` fails fast so UI changes are visible instead of hidden by repeated blind retries.

## Worker offline behavior
- if worker misses stale threshold, mark worker offline
- if active job lease expires, mark job orphaned
- orphaned jobs are not silently dropped

## Human intervention statuses
Human intervention is represented as server workflow state, not a worker job/runtime state:
- `waiting_human_review`
- `needs_reauth`
- `needs_operator_review`

Worker jobs must be terminal or the worker must be idle before human review begins.

## Mandatory observability
Every failed job must preserve:
- structured failure type
- last step name
- step log path or inline summary
- debug screenshot if available
- artifact upload status
