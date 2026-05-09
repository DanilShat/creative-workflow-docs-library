# File Transfer and Artifact Protocol

## Storage principle
PostgreSQL stores metadata. Binary media and debug artifacts live on disk under `ARTIFACT_ROOT`.

## Path policy
Server controls all final paths. Worker submits metadata and file content; server chooses storage path.

No client-provided path may be trusted.
No uploaded filename may be used directly without sanitization.
No `..`, absolute paths, or path separators from original filename are allowed in final paths.

## Multipart upload
Endpoint: `POST /api/v1/assets/upload`

Fields:
- `file`: binary file
- `metadata`: JSON string

Metadata schema:
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
  "sha256": "hex string",
  "source_service": "gemini | freepik | kling | photoshop | aftereffects | claude | manual",
  "debug_kind": "screenshot | trace | html_snapshot | step_log | raw_text | null"
}
```

Server response:
```json
{
  "asset_id": "asset_123",
  "stored": true,
  "sha256_verified": true,
  "relative_path": "tasks/task_456/generated/asset_123.png"
}
```

## Server asset metadata
Required DB fields:
- asset_id
- task_id
- run_id nullable
- job_id nullable
- asset_class
- retention_class
- original_filename
- stored_filename
- relative_path
- content_type
- size_bytes
- sha256
- source_service
- debug_kind nullable
- created_at

## Retention
- `reference`: keep by default
- `generated`: keep if selected, otherwise ttl_30d
- `intermediate`: ttl_7d or ttl_30d
- `debug`: debug_ttl_7d
- `export`: keep

## Active-job deletion guard
Retention cleanup must not delete assets referenced by active/running/orphan-recoverable jobs.

## Checksum
Worker computes sha256 before upload.
Server recomputes sha256 after upload and rejects mismatch.

## Download
Worker downloads input assets through server endpoint and verifies checksum if provided.
