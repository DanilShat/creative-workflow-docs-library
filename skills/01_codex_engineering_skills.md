# Codex Engineering Skills

Codex must demonstrate these skills while implementing the repository.

## 1. Delivery skill
- Build a **real runnable MVP**, not scaffolding theater.
- Avoid placeholder architecture without working execution paths.
- Do not leave critical flows as TODO, pass, stub, fake implementation, or “later”.

## 2. Systems design skill
- Preserve the chosen architecture: server on operator laptop, worker on designer laptop.
- Keep local LLM limited to orchestration.
- Keep browser and DCC execution on worker side.
- Respect allowlisted actions and contracts.

## 3. Code quality skill
- Write code that is understandable by an ML engineer learning from it.
- Use clear module boundaries.
- Prefer explicit names over clever abstractions.
- Keep configuration centralized.

## 4. Commenting skill
- Add comments that explain **why the component exists**, not just what syntax does.
- Explain functional components, state transitions, protocol decisions, and failure handling.
- Avoid noisy comments that restate obvious code.

## 5. Testing skill
- Cover contracts, lifecycle, state transitions, and failure classes.
- Avoid tautological tests that only repeat implementation details.
- Include meaningful integration tests where feasible.

## 6. Operational skill
- Produce scripts and runbooks that match the actual repository.
- Keep paths, environment variables, and startup steps consistent.
- Make the project runnable by a human operator without hidden knowledge.
