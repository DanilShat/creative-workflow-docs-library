Now perform a runbook and smoke-validation pass.

Tasks:
- verify the repository contains all required startup scripts and setup instructions;
- verify the runbook is complete and consistent with the code;
- verify ports, paths, env vars, database setup, and local model setup are all coherent;
- verify the worker registration, heartbeat, polling, job claim, artifact upload, and completion path are covered by code and tests;
- verify at least one real browser flow path exists in the codebase;
- verify Photoshop and After Effects bridges have clear boundaries and startup expectations.

Then produce an operator-facing handoff with:
1. setup order,
2. exact commands,
3. smoke test order,
4. what success should look like at each stage,
5. what to do if a stage fails,
6. what should be checked manually on the operator laptop,
7. what should be checked manually on the designer laptop.
