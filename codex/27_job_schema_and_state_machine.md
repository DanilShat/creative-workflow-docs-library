# Job Schema and State Machine

## Job envelope
```json
{
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
  "timeout_s": 1200,
  "lease_ttl_s": 90,
  "retry_policy": {
    "max_attempts": 2,
    "retryable_failure_types": ["network_temporary", "upload_failed"]
  }
}
```

## Minimum DB entities for Gate A
PostgreSQL stores metadata and workflow history only. Binary media, screenshots, traces and downloaded files live on disk under `ARTIFACT_ROOT`.

### workers
Required fields:
- worker_id
- display_name nullable
- version nullable
- capabilities
- host_apps
- profile_status
- machine_info
- status
- last_heartbeat_at nullable
- active_job_id nullable
- created_at
- updated_at

### worker_tokens
Required fields:
- worker_id
- token_hash
- revoked_at nullable
- created_at
- last_used_at nullable

Raw worker tokens must never be stored or logged.

### tasks
Required fields:
- task_id
- title
- brief_text
- requested_output_type
- workflow_state
- created_by
- created_at
- updated_at

### runs
Required fields:
- run_id
- task_id
- attempt_number
- status
- source_review_id nullable
- created_at
- completed_at nullable

### jobs
Required fields:
- job_id
- task_id
- run_id
- job_type
- required_capability
- action_name
- inputs_json
- state
- claimed_by_worker_id nullable
- claimed_at nullable
- lease_expires_at nullable
- attempt_number
- retry_policy_json
- failure_type nullable
- failure_message nullable
- created_at
- started_at nullable
- completed_at nullable

### prompts
Required fields:
- prompt_id
- task_id
- run_id
- job_id nullable
- prompt_role
- prompt_text
- negative_prompt nullable
- prompt_language nullable
- source_service
- raw_response_asset_id nullable
- created_at

### assets
Required fields are defined in `codex/28_file_transfer_and_artifact_protocol.md`.

### reviews
Required fields:
- review_id
- task_id
- run_id
- decision
- selected_asset_id nullable
- reason nullable
- created_at

### workflow_events
Required fields:
- event_id
- task_id
- run_id nullable
- job_id nullable
- event_type
- payload_json
- created_at

Gate A is not implementation-complete if task, run, job, prompt, asset, review or workflow history exists only in memory.

## Job types
- `browser_flow`
- `photoshop_action`
- `aftereffects_action`
- `asset_prepare`
- `claude_mcp_requested_action` only as server-created job request, not direct execution

## Browser flow result contract
All browser flows return:
```json
{
  "service": "gemini | freepik | kling | higgsfield | google_flow",
  "flow_name": "string",
  "profile_status": "authenticated | needs_setup | expired | broken",
  "structured_output": {},
  "artifact_ids": [],
  "debug_asset_ids": [],
  "external_urls": [],
  "failure_class": null
}
```

### Gemini prompt-builder structured output
```json
{
  "prompt_text": "string",
  "negative_prompt": "string optional",
  "prompt_language": "en | uk | ru | mixed",
  "extracted_from_response": true,
  "raw_response_asset_id": "asset_debug_text optional"
}
```

### Freepik generation structured output
```json
{
  "generated_asset_ids": ["asset_generated_1"],
  "selected_asset_id": "asset_generated_1 optional",
  "downloaded_files_count": 1,
  "provider_visible_model": "string optional",
  "credits_visible": "string optional"
}
```

## Local LLM output schemas

### Brief normalization
```json
{
  "goal": "string",
  "job_type": "static | video | unknown",
  "style": "string optional",
  "format": "string optional",
  "must_have": ["string"],
  "must_not_have": ["string"],
  "missing_info": ["string"],
  "confidence": 0.0
}
```

### Route decision
```json
{
  "next_step": "gemini_prompt_builder | freepik_image_generation | human_clarification | wait_human_review",
  "required_capability": "browser.gemini | browser.freepik | none",
  "reason": "string",
  "job_request": {}
}
```

### Retry/repair decision
```json
{
  "decision": "retry_with_prompt_repair | ask_human | accept | stop",
  "repair_instruction": "string optional",
  "new_job_request": "object optional",
  "reason": "string"
}
```

## Worker runtime states
- starting
- registering
- idle
- claiming
- preparing_inputs
- running
- uploading_outputs
- error
- stopping

No `waiting_human` worker runtime state.

## Job execution states
- claimed
- local_preparing
- executing
- collecting_outputs
- uploading_artifacts
- completed
- failed_retryable
- failed_fatal

## Server workflow human-review states
- waiting_human_review
- human_approved
- human_rejected
- retry_requested

## Rules
- completed jobs never return to running
- only one terminal state is allowed
- upload step is explicit
- human review creates new workflow events, not active worker leases
- host actions never contain raw code fields
