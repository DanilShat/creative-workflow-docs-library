---
name: claude-mcp-delegate
summary: Design Claude Desktop as an optional delegated orchestrator through local MCP tools without making it core runtime dependency.
---

# Claude MCP Delegate Skill

Use this skill when adding or reviewing Claude Desktop integration.

## Core principle
Claude is optional. The system must work without Claude.

Claude may operate through a local MCP server on the designer laptop and call allowlisted tools exposed by the worker/server system.

## Must enforce
- No direct DB writes from Claude tools.
- No arbitrary Photoshop/After Effects code execution.
- No raw browser automation access from Claude.
- No bypassing server-owned workflow state.
- All actions are typed, allowlisted, audited, and routed through worker/server contracts.

## Preferred tools
- `get_current_task_context`
- `list_available_actions`
- `submit_review_note`
- `request_browser_flow_job`
- `request_photoshop_action_job`
- `request_aftereffects_action_job`

## Integration modes
1. Claude-initiated: designer asks Claude to help with current task.
2. Server handoff: app creates prompt packet for Claude.
3. API delegate: optional future mode requiring Anthropic API key.

## Acceptance
A correct implementation:
- starts an MCP server locally on the designer laptop;
- exposes typed tools;
- authenticates to the worker/server layer using configured local credentials;
- can fetch task context;
- can submit review notes;
- can request allowlisted jobs;
- does not become mandatory for the first browser E2E slice.
