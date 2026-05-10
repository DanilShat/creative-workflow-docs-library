# Start Here

This repository is the documentation and specification library for the
Creative Workflow project. It is not the deployed app.

## Three repos, one project

- `creative_workflow_docs_library` = specs, runbooks, skills, prompts.
- `creative_workflow_operator` = runs on the operator laptop.
- `creative_workflow_worker` = runs on each designer laptop.

```text
Operator laptop (creative_workflow_operator) <--> Designer laptop worker (creative_workflow_worker)
```

## Recommended first pass

1. Read `README.md` for the library index.
2. Read `codex/00_README_FOR_CODEX.md` for implementation context.
3. Read `codex/31_implementation_master_plan.md` for the planned build order.
4. Read `runtime_docs/gate_a_runbook.md` for the runnable Gate A path.
5. Use `prompts/README_ua.md` only when running the historical Codex prompt sequence.

## Ukrainian original

The original Ukrainian onboarding file is kept as `README_START_HERE.uk.md`.
It is retained for context, but this English file is the visitor-facing entry
point.
