# GitHub Skills Source Map

This file lists the strongest relevant GitHub/open sources used to redesign the skills folder.

## Format and meta-design

### Agent Skills specification
- Source: https://agentskills.io/specification
- Used for: folder-per-skill structure, `SKILL.md` frontmatter, progressive disclosure, keeping `SKILL.md` lean.
- Import status: concept/pattern only.

### Anthropic engineering article on Agent Skills
- Source: https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills
- Used for: progressive disclosure model and skill packaging rationale.
- Import status: concept/pattern only.

## Engineering quality

### addyosmani/agent-skills
- Source: https://github.com/addyosmani/agent-skills
- License: MIT
- Why useful: production-grade engineering skills, quality gates, define-plan-build-verify-review-ship flow.
- Used for: `production-engineering`, `testing-quality-gates`.
- Import status: adapted ideas only, not copied content.

### VoltAgent/awesome-agent-skills
- Source: https://github.com/VoltAgent/awesome-agent-skills
- License: MIT
- Why useful: hand-picked curated index of official/community skills; useful for finding high-signal sources.
- Used for: source discovery.
- Import status: index/reference only.

### ComposioHQ/awesome-claude-skills
- Source: https://github.com/ComposioHQ/awesome-claude-skills
- Why useful: good explanation of skills vs MCP/tools and progressive loading.
- Used for: source discovery and terminology.
- Import status: reference only.

## Browser automation

### lackeyjb/playwright-skill
- Source: https://github.com/lackeyjb/playwright-skill
- Why useful: Playwright skill oriented around visible browser, progressive disclosure, safe cleanup.
- Used for: `playwright-browser-automation`.
- Import status: adapted patterns only.

### willcoliveira/qualiow-playwright-skills
- Source: https://github.com/willcoliveira/qualiow-playwright-skills
- Why useful: Playwright E2E patterns, wait strategies, selectors, POM, debugging decision trees.
- Used for: `playwright-browser-automation`, `testing-quality-gates`.
- Import status: adapted patterns only.

## Agent/context architecture

### muratcankoylan/Agent-Skills-for-Context-Engineering
- Source: https://github.com/muratcankoylan/agent-skills-for-context-engineering
- License: MIT
- Why useful: context engineering, tool design, memory systems, context compression, evaluation skills.
- Used for: `context-engineering`, `server-worker-runtime`.
- Import status: adapted patterns only.

## Adobe / creative host apps

### adobe/skills
- Source: https://github.com/adobe/skills
- License: Apache-2.0
- Why useful: official Adobe skills repository and example of Adobe-oriented skill packaging.
- Used for: Adobe integration skill framing.
- Import status: reference only.

### Adobe Photoshop UXP code samples
- Source: https://developer.adobe.com/photoshop/uxp/2022/guides/code_samples/
- Why useful: official UXP plugin starting point and UI conventions.
- Used for: `photoshop-uxp-companion`.
- Import status: reference only.

### bubblydoo/uxp-toolkit
- Source: https://github.com/bubblydoo/uxp-toolkit
- Why useful: practical Photoshop UXP tooling and MCP/DevTools ideas.
- Used for: `photoshop-uxp-companion`.
- Import status: adapted design ideas only, no script import.

### aedev-tools/adobe-agent-skills
- Source: https://github.com/aedev-tools/adobe-agent-skills
- License: Apache-2.0
- Why useful: After Effects automation skill, undo groups, project querying, built-in scripts.
- Used for: `after-effects-bridge`.
- Import status: design reference only; do not copy arbitrary code execution model into MVP.

### yumehiko/ae-agent-skills
- Source: https://github.com/yumehiko/ae-agent-skills
- Why useful: concrete AE agent architecture with CEP panel, CLI, schemas and declarative skill.
- Used for: `after-effects-bridge`.
- Import status: architecture reference only.

## Security note

Skills are code-adjacent supply-chain artifacts. Treat external skills like dependencies: inspect license, scripts, install steps, network/file access, and whether they encourage arbitrary code execution.



## Reviewer-first skill sources added in v9

The reviewer skills are project-specific adaptations inspired by these external references:

1. `awesome-skills/code-review-skill`
   - Used as inspiration for structured review phases, severity labels, and separating blocking findings from learning/nit feedback.
   - Not copied wholesale; this project needs spec/system review before code, not only PR-level review.

2. `VoltAgent/awesome-claude-code-subagents` — `architect-reviewer`
   - Used as inspiration for macro architecture review dimensions: design decisions, scalability, integration patterns, security, maintainability, technical debt, and evolution path.
   - Adapted into a Codex-compatible `SKILL.md` folder for this project.

3. `addyosmani/agent-skills`
   - Used as inspiration for production-grade engineering discipline: define, plan, build, verify, review, ship.
   - Adapted into strict MVP gatekeeping: avoid prototype-quality shortcuts and mock-only paths.

4. Official Codex Agent Skills documentation
   - Used for skill packaging assumptions: a skill is a directory with `SKILL.md`, optional resources, and concise trigger descriptions.

5. `github/awesome-copilot` agent skills docs
   - Used as a compatibility reference for self-contained skill folders and progressive disclosure style.

Security note: external skills are references only. Do not blindly copy or execute bundled scripts from external repositories.
