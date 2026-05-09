# Test Strategy and Quality Bar

## Goal

Tests must prove that the system is safe to evolve and that the core MVP really works.

## Test pyramid for this project

### Unit tests
Cover:
- schema validation
- parsers
- path builders
- routing policy
- error classifiers
- retry/lease calculations
- config loading

### Service-level tests
Cover:
- worker registration
- heartbeat updates
- claim-next-job behavior
- lease expiry recovery
- artifact metadata writes
- job status transitions

### Integration tests
Cover:
- server + database
- worker + server protocol
- local LLM client contract
- browser runtime setup and failure classification
- Photoshop/AE bridge contract payloads

### Acceptance tests
Cover at least:
- create task
- worker claims task
- Gemini prompt flow
- Freepik generation flow
- artifact returns to server
- UI shows result
- approve/reject path updates state

## What not to test

Do not write low-value tests that:
- merely repeat implementation branches,
- assert the obvious,
- overfit internal private method structure,
- exist only to inflate coverage.

## Coverage philosophy

Coverage is a signal, not a target.
High-value areas must be tested even if total line coverage is modest.

## Required failure tests

Must test:
- stale worker lease
- worker restart during active job
- browser auth expired
- artifact upload failure
- timeout in long generation wait
- selector broken classification
- Photoshop unavailable
- AE unavailable

## Merge bar

Do not consider core implementation complete unless:
- critical schemas are tested,
- server-worker lifecycle is tested,
- at least one browser flow has an executable acceptance path,
- no core runtime path depends on mocks.
