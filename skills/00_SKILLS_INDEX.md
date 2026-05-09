# Skills Index

This folder now uses a stronger, GitHub-researched structure inspired by the Agent Skills open format: each concrete skill is a directory with `SKILL.md`.

## Why this structure

Agent skills work best through progressive disclosure: the agent sees short metadata first, then loads the full skill only when relevant. Each skill below is intentionally narrow and action-oriented.

## Curated project skills

- `production-engineering/` — build real production-minded code, not demo scaffolding.
- `context-engineering/` — keep long implementation sessions focused and prevent context bloat.
- `playwright-browser-automation/` — implement reliable browser automation with Playwright.
- `server-worker-runtime/` — implement the two-machine server/worker runtime.
- `photoshop-uxp-companion/` — build the Photoshop side-panel/bridge safely.
- `after-effects-bridge/` — build the After Effects bridge with allowlisted actions.
- `testing-quality-gates/` — write tests that prove behavior, not implementation duplication.
- `operator-deployment/` — produce install/run/diagnostic scripts and operator-grade runbooks.

## Source policy

These skills are not blind copies of GitHub repos. They are project-specific adaptations informed by the sources listed in `GITHUB_SKILLS_SOURCE_MAP.md`.

Rules:

1. Do not execute third-party scripts from external skills without manual audit.
2. Do not add arbitrary-code-execution DCC actions to MVP.
3. Keep skills small and verifiable.
4. Keep source attribution.
- `claude-mcp-delegate/SKILL.md` — optional Claude Desktop + MCP delegated orchestrator design.
