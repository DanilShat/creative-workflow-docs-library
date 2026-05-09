# Implementation Master Plan

## Current first target
Build Gate A: browser-first real vertical slice.

DCC and Claude integrations are post-Gate-A. Their contracts may be scaffolded, but live acceptance is separate.

## Phase 0 — read/review
- Read reviewer-first protocol.
- Read blocker fixes.
- Confirm no contradictions with Gate A.

## Phase 1 — repo foundation
- packages: server, worker, shared contracts, browser runtime, storage, tests
- config system
- comments/docstrings explaining functional components

## Phase 2 — database/storage
- Postgres models/migrations
- artifact root
- file metadata
- checksum validation

## Phase 3 — server API
- worker auth/bootstrap
- register/heartbeat/claim/progress/complete/fail
- asset download/upload
- task creation
- human review workflow

## Phase 4 — worker core
- config check
- register/heartbeat/polling loop
- one active job invariant
- asset download/upload
- failure classification

## Phase 5 — local LLM orchestration
- Ollama-compatible client
- strict JSON output parser
- schemas for brief normalization, routing, retry/repair decision
- fallback behavior when JSON invalid

## Phase 6 — browser runtime
- Playwright setup
- persistent profiles
- profile setup/status commands
- debug artifact capture

## Phase 7 — Gemini flow
- real browser prompt-builder flow
- structured prompt result
- debug artifacts

## Phase 8 — Freepik flow
- real browser image generation/download flow
- artifact upload
- debug artifacts

## Phase 9 — Gate A validation
- run live Gemini + Freepik E2E
- verify history, artifacts, human review and retry

## Phase 10 — DCC contracts
- Photoshop/AE typed host-action contracts
- bridge skeletons
- no live acceptance unless real host apps are connected

## Phase 11 — Claude delegate layer
- optional MCP server skeleton
- task context tool
- review note tool
- allowlisted action-request tools
- not required for Gate A

## Phase 12 — hardening
- tests
- runbook verification
- cleanup/retention
- failure-mode checks
