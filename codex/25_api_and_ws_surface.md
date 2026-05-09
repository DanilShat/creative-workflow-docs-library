# API Surface and Canonical Schemas

## MVP rule
Worker execution is HTTP + polling. WebSocket is optional for future UI progress only.

All worker endpoints require:

```http
Authorization: Bearer <WORKER_TOKEN>
Content-Type: application/json
```

Common error response:
```json
{
  "error": {
    "code": "invalid_token | token_revoked | registration_disabled | validation_error | not_found | conflict | job_not_owned | lease_expired | internal_error",
    "message": "human-readable summary",
    "details": {}
  }
}
```

## POST /api/v1/workers/register

Request:
```json
{
  "worker_id": "designer-laptop-01",
  "display_name": "Designer Laptop",
  "version": "0.1.0",
  "capabilities": ["browser.playwright", "browser.gemini", "browser.freepik"],
  "host_apps": {
    "photoshop": {"installed": true, "connected": false, "version": null},
    "aftereffects": {"installed": true, "connected": false, "version": null}
  },
  "profiles": {
    "gemini": {"status": "unknown"},
    "freepik": {"status": "unknown"}
  },
  "machine_info": {
    "hostname": "DESIGNER-PC",
    "os": "windows",
    "user_session_active": true
  }
}
```

Response:
```json
{
  "worker_id": "designer-laptop-01",
  "registered": true,
  "server_time": "2026-05-04T12:00:00Z",
  "heartbeat_interval_s": 15,
  "claim_poll_interval_s": 3,
  "active_job": null
}
```

## POST /api/v1/workers/heartbeat

Request:
```json
{
  "worker_id": "designer-laptop-01",
  "status": "idle | running | stopping | error",
  "active_job_id": null,
  "capabilities": ["browser.playwright", "browser.gemini", "browser.freepik"],
  "profile_status": {
    "gemini": "authenticated",
    "freepik": "authenticated"
  },
  "host_app_status": {
    "photoshop": "unavailable",
    "aftereffects": "unavailable"
  },
  "health": {
    "free_disk_mb": 100000,
    "browser_runtime_ok": true
  }
}
```

Response:
```json
{
  "accepted": true,
  "server_time": "2026-05-04T12:00:00Z",
  "active_job_lease_expires_at": null,
  "commands": []
}
```

## POST /api/v1/workers/claim-next

Request:
```json
{
  "worker_id": "designer-laptop-01",
  "capabilities": ["browser.gemini", "browser.freepik"],
  "active_job_id": null
}
```

Response when no job:
```json
{"job": null, "poll_after_s": 3}
```

Response with job:
```json
{
  "job": {
    "job_id": "job_123",
    "task_id": "task_456",
    "run_id": "run_789",
    "job_type": "browser_flow",
    "required_capability": "browser.freepik",
    "action_name": "freepik_generate_image_from_prompt",
    "inputs": {
      "prompt": "...",
      "refs": ["asset_ref_1"],
      "settings": {"aspect_ratio": "1:1"}
    },
    "input_assets": [
      {
        "asset_id": "asset_ref_1",
        "download_url": "/api/v1/assets/asset_ref_1/download",
        "sha256": "...",
        "content_type": "image/png",
        "filename": "ref.png"
      }
    ],
    "timeout_s": 1200,
    "lease_ttl_s": 90,
    "lease_expires_at": "2026-05-04T12:01:30Z",
    "idempotency_key": "job_123_attempt_1"
  }
}
```

## POST /api/v1/jobs/{job_id}/progress

Request:
```json
{
  "worker_id": "designer-laptop-01",
  "state": "preparing_inputs | executing | collecting_outputs | uploading_artifacts",
  "step": "wait_for_result",
  "message": "Freepik generation is processing",
  "percent": null,
  "debug_asset_ids": [],
  "timestamp": "2026-05-04T12:00:00Z"
}
```

Response:
```json
{"accepted": true}
```

## POST /api/v1/jobs/{job_id}/complete

Request:
```json
{
  "worker_id": "designer-laptop-01",
  "outputs": {
    "flow_result": {
      "service": "freepik",
      "flow_name": "freepik_generate_image_from_prompt",
      "profile_status": "authenticated",
      "downloaded_asset_ids": ["asset_generated_1"],
      "debug_asset_ids": ["asset_trace_1", "asset_screenshot_1"]
    },
    "structured_output": {}
  },
  "artifact_ids": ["asset_generated_1", "asset_trace_1", "asset_screenshot_1"],
  "completed_at": "2026-05-04T12:10:00Z"
}
```

Response:
```json
{"accepted": true, "server_workflow_state": "waiting_human_review"}
```

## POST /api/v1/jobs/{job_id}/fail

Request:
```json
{
  "worker_id": "designer-laptop-01",
  "failure_type": "needs_reauth | dependency_unavailable | selector_broken | upload_failed | download_failed | network_temporary | provider_quota_or_paywall | browser_profile_broken | transient_browser_start_failure | photoshop_not_connected | aftereffects_not_connected | invalid_job_payload | unsupported_action_name | fatal_unexpected",
  "retryable": false,
  "message": "Gemini profile is not authenticated",
  "debug_asset_ids": ["asset_screenshot_1"],
  "failed_at": "2026-05-04T12:05:00Z"
}
```

Response:
```json
{"accepted": true, "next_state": "failed_fatal"}
```

## GET /api/v1/assets/{asset_id}/download
Returns file bytes. Worker must verify checksum if provided in job input.

## POST /api/v1/assets/upload
Multipart fields:

- `file`: binary file
- `metadata`: JSON string

Metadata:
```json
{
  "task_id": "task_456",
  "run_id": "run_789",
  "job_id": "job_123",
  "asset_class": "reference | generated | debug | export | intermediate",
  "retention_class": "keep | ttl_30d | ttl_7d | debug_ttl_7d",
  "original_filename": "output.png",
  "content_type": "image/png",
  "size_bytes": 123456,
  "sha256": "...",
  "source_service": "freepik",
  "debug_kind": null
}
```

Response:
```json
{
  "asset_id": "asset_generated_1",
  "stored": true,
  "sha256_verified": true,
  "relative_path": "tasks/task_456/generated/asset_generated_1.png"
}
```

## Gate A task and review endpoints
These endpoints are the minimum server/UI contract for the first real vertical slice. Streamlit calls these server-side services only. The UI never calls the worker directly.

## POST /api/v1/tasks
Creates a user task and initial workflow record.

Request:
```json
{
  "title": "Product hero image",
  "brief_text": "Create a square product hero based on the reference.",
  "requested_output_type": "static_image",
  "created_by": "operator"
}
```

Response:
```json
{
  "task_id": "task_456",
  "workflow_state": "draft",
  "created_at": "2026-05-04T12:00:00Z"
}
```

## POST /api/v1/tasks/{task_id}/references
Attaches an uploaded reference asset to a task. The file is stored through the same artifact storage path policy as worker uploads.

Multipart fields:
- `file`: binary reference file
- `metadata`: JSON string

Metadata:
```json
{
  "original_filename": "ref.png",
  "content_type": "image/png",
  "size_bytes": 123456,
  "sha256": "...",
  "source_service": "manual"
}
```

Response:
```json
{
  "task_id": "task_456",
  "asset_id": "asset_ref_1",
  "asset_class": "reference",
  "retention_class": "keep",
  "stored": true
}
```

## POST /api/v1/tasks/{task_id}/start-gate-a
Starts the Gate A orchestration path after the task has at least one reference asset.

Request:
```json
{
  "task_id": "task_456",
  "operator_note": "Use the reference as visual direction."
}
```

Response:
```json
{
  "task_id": "task_456",
  "run_id": "run_789",
  "workflow_state": "waiting_worker",
  "created_job_ids": ["job_gemini_1"]
}
```

## GET /api/v1/tasks/{task_id}
Returns task summary for the Streamlit UI.

Response:
```json
{
  "task_id": "task_456",
  "title": "Product hero image",
  "brief_text": "Create a square product hero based on the reference.",
  "workflow_state": "waiting_human_review",
  "latest_run_id": "run_789",
  "reference_asset_ids": ["asset_ref_1"],
  "latest_generated_asset_ids": ["asset_generated_1"]
}
```

## GET /api/v1/tasks/{task_id}/history
Returns ordered task history for the Streamlit timeline.

Response:
```json
{
  "task_id": "task_456",
  "runs": [],
  "jobs": [],
  "prompts": [],
  "assets": [],
  "reviews": [],
  "workflow_events": []
}
```

## POST /api/v1/tasks/{task_id}/reviews
Records operator approval or rejection after worker completion. This is a server workflow action, not a worker job state.

Request:
```json
{
  "run_id": "run_789",
  "decision": "approved | rejected",
  "selected_asset_id": "asset_generated_1",
  "reason": "Needs stronger brand colors."
}
```

Response:
```json
{
  "review_id": "review_123",
  "task_id": "task_456",
  "workflow_state": "human_approved | human_rejected"
}
```

## POST /api/v1/tasks/{task_id}/retry
Creates a new repair/retry job after rejection. Previous runs and assets remain visible in history.

Request:
```json
{
  "source_run_id": "run_789",
  "review_id": "review_123",
  "repair_instruction": "Make the image brighter and use stronger brand colors."
}
```

Response:
```json
{
  "task_id": "task_456",
  "run_id": "run_790",
  "workflow_state": "waiting_worker",
  "created_job_ids": ["job_gemini_retry_1"]
}
```

## UI endpoints
UI talks only to the server. UI never calls the worker directly.
