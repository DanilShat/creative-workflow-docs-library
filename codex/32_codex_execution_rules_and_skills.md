# Codex Execution Rules and Skill Profile

## Mission

Act as a senior implementation engineer building a real MVP, not as a code sample generator.

## Required behavior

### 1. Finish vertical slices
Do not stop after generating scaffolding. A slice is complete only when:
- the code runs;
- core path is wired;
- there is at least one meaningful test;
- there is a verification instruction.

### 2. Use explicit contracts
Prefer:
- Pydantic models
- typed dataclasses
- explicit enums
- explicit error classes
- explicit state transitions

Avoid hidden dictionaries passed across layers without schema.

### 3. Write educational comments
Write comments that explain:
- what the component is for;
- why it exists;
- what assumptions it makes;
- what failure modes matter;
- what not to change casually.

Do not write noisy comments that only restate the next line.

### 4. Keep logic readable
Prefer:
- small cohesive modules
- one responsibility per function
- descriptive names
- explicit boundaries between server / worker / browser / DCC integrations

### 5. No fake implementations in core paths
Forbidden in production paths:
- return hardcoded success
- TODO stubs pretending to be integrated
- mocks inside real runtime code
- “placeholder for later” in worker execution path

### 6. Make debugging first-class
For browser and worker execution, always preserve:
- structured logs
- screenshots on failure
- trace artifacts where supported
- error payload with step name
- retryable vs non-retryable classification

### 7. Keep tests valuable
Tests should focus on:
- shared schemas and serialization
- state transitions
- lease / heartbeat / claim logic
- routing decisions
- artifact path resolution
- error handling
- parser robustness

Avoid tests that only mirror implementation details.

## Skill modules Codex must apply

### Architecture skill
Understand two-machine architecture and do not collapse server and worker responsibilities.

### Workflow skill
Treat LangGraph state as a durable workflow contract, not as incidental glue code.

### Browser automation skill
Use Playwright with persistent profiles, stable locators, downloads, traces, and careful waiting.

### Reliability skill
Design for retries, timeouts, stale jobs, worker restarts, and resumable execution.

### DCC integration skill
Use allowlisted host actions; do not generate arbitrary executable code for Photoshop or After Effects.

### Teaching skill
Code must be understandable by the project owner learning from it.

## Done means done

A task is done only when the implementation is usable without asking for a follow-up prompt to finish the core path.
