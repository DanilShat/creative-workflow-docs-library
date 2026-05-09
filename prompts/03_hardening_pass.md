Now do a hardening pass.

Tasks:
- inspect the whole repository for incomplete paths, placeholders, TODOs, fake implementations, and weak tests;
- fix anything that prevents this from being a real MVP;
- tighten comments and docstrings where the code is not self-explanatory;
- verify the deployment/runbook matches the actual code;
- verify configuration, environment variables, paths, and scripts are consistent;
- make sure tests are meaningful and not tautological;
- make sure failure modes and retries are implemented according to spec;
- make sure acceptance criteria are actually reflected in the codebase.

Then produce a final hardening report with:
1. what you fixed,
2. what risks remain,
3. what must still be configured manually by the operator,
4. what manual checks should be done on server and worker machines.
