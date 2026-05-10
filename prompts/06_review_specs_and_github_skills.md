# Prompt 06 — Review specs and use the GitHub-researched skills

Use this prompt when you want Codex to re-check the architecture before implementation or before a major hardening pass.

```text
Read the following files first:

- archive/reviews/SPEC_REVIEW_2026_05_04.md
- skills/00_SKILLS_INDEX.md
- skills/GITHUB_SKILLS_SOURCE_MAP.md
- skills/production-engineering/SKILL.md
- skills/context-engineering/SKILL.md
- skills/playwright-browser-automation/SKILL.md
- skills/server-worker-runtime/SKILL.md
- skills/photoshop-uxp-companion/SKILL.md
- skills/after-effects-bridge/SKILL.md
- skills/testing-quality-gates/SKILL.md
- skills/operator-deployment/SKILL.md
- codex/37_spec_review_and_gap_fixes.md

Then compare these correction files against the implementation plan and current repository.

Your task:
1. identify contradictions or missing implementation paths;
2. update the implementation plan if needed;
3. apply the relevant skills during coding;
4. keep external GitHub skills as design references only unless explicitly approved;
5. do not import or execute third-party scripts without audit;
6. ensure the first vertical slice is real: server task -> worker browser flow -> Gemini prompt -> Freepik generation -> artifact upload -> review/history.

Do not expand scope. Fix only gaps that block a real working MVP.

Output:
- gap list;
- exact files you will change;
- implementation order;
- verification checklist.

After that, wait for my approval before large code changes.
```
