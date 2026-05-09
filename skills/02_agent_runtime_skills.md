# Agent Runtime Skills

The local orchestrator LLM and surrounding runtime must support these skills.

## Core orchestration skills
- Convert raw task brief into structured brief.
- Classify task type: static vs video.
- Select next tool/skill based on current workflow state.
- Summarize human feedback into machine-usable repair instructions.
- Keep workflow state compact and explicit.

## Routing skills
- Choose browser flow skill by job type and availability.
- Choose host action skill by user request and current context.
- Escalate to human when ambiguity or repeated failure appears.

## Reliability skills
- Respect allowlists.
- Emit machine-readable decisions.
- Keep state resumable.
- Surface retryable vs non-retryable failures.

## Non-goals
- The local LLM is not the universal creative model.
- It should not do heavy multimodal generation or expensive visual reasoning.
- Prompt generation and repair for creative tasks can use browser-based Gemini or other external web tools.
