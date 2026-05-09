# Code Style and Commenting Contract

## General style

- Prefer clarity over cleverness.
- Prefer explicit control flow over implicit framework magic.
- Prefer typed boundaries over ad-hoc dynamic payloads.
- Prefer dependency injection at module boundaries where it improves testability.

## Required comments

Write comments for:
- public modules and packages
- orchestration nodes
- worker execution loop
- claim/lease logic
- browser wait conditions
- storage path conventions
- Photoshop/AE host bridge safety boundaries
- cleanup and retention jobs

Each important module should start with a short header comment explaining:
1. what it owns,
2. what it does not own,
3. which other modules it collaborates with.

## Function comments

Functions need comments when:
- the behavior is non-obvious,
- the sequencing matters,
- there is a safety restriction,
- a retry/timeout choice is intentional.

## Forbidden comment patterns

Do not write:
- trivial restatements of the next line,
- outdated comments,
- vague “handle errors” comments,
- unexplained magic constants.

## Naming

Prefer names that expose intention:
- `claim_next_job`
- `classify_failure`
- `resolve_artifact_upload_path`
- `build_prompt_repair_request`

Avoid names like:
- `do_job`
- `handle_data`
- `process_item`
- `helper1`

## Logging

Logs must be structured enough to answer:
- what job ran,
- on which worker,
- at which step,
- with which result,
- why it failed if it failed.
