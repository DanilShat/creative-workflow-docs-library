# Manual Live Browser Gate A

Automated tests validate contracts and state transitions. This manual checklist
is required because Gemini and Freepik require real accounts and live browser
sessions.

1. Run `server dev` and `server ui`.
2. Run `worker profile setup gemini` and log in.
3. Run `worker profile setup freepik` and log in.
4. Run `worker run`.
5. Create a task in Streamlit with one reference image.
6. Confirm Gemini job completes and creates a prompt row.
7. Confirm Freepik downloads a real generated file.
8. Confirm the worker is idle while the task waits for human review.
9. Reject the result and confirm a retry job is created.

