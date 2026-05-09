# CURRENT TOPOLOGY WARNING

This older file is superseded where it conflicts with:
- `codex/21_server_worker_architecture.md`
- `codex/39_reviewer_blocker_fixes_applied.md`
- `codex/30_server_worker_acceptance_suite.md`

Current topology: server/control plane runs on operator laptop; worker/execution plane runs on designer laptop. First MVP gate is Gemini + Freepik browser E2E. DCC comes after Gate A.

---

# System Specification

## Name
Local Creative Workflow Orchestrator (LCWO)

## Product goal
Replace ad-hoc multi-tab AI generation work with a structured workflow system that preserves context, prompt history, run history, selected outputs, and review decisions.

## Core design
This is **not** a free-form autonomous agent.
This is a **workflow-driven application with agentic nodes**.

## Constraints
- no organization-level API call workflow available;
- vendor interaction must work through browser automation first;
- local-only deployment;
- data growth must remain manageable;
- human review remains mandatory.


## Control plane and execution plane
The final deployment model is split across two machines:
- control plane on the owner laptop: FastAPI, LangGraph, local LLM runtime, PostgreSQL, artifact index;
- execution plane on the designer laptop: browser worker, Photoshop panel bridge, After Effects bridge, local temp storage.

The orchestrator decides and records state centrally, while execution is delegated to worker capabilities on the designer machine.
