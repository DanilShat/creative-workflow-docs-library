---
name: playwright-browser-automation
description: Use when implementing or debugging browser automation flows for Gemini, Freepik, Kling, Google Flow, Higgsfield, uploads, downloads, sessions, screenshots, traces, or selectors.
---

# Playwright Browser Automation Skill

## Use when

Use this skill for:

- Gemini prompt-builder flow;
- Freepik image/video generation flow;
- Kling/Flow/Higgsfield browser flows;
- persistent browser profiles;
- upload/download handling;
- live browser debugging;
- flow reliability hardening.

## Architecture rule

Browser automation must live on the designer worker, not on the server.

## Flow structure

Every browser flow should follow this state machine:

1. `open_service`
2. `ensure_profile_authenticated`
3. `dismiss_known_popups`
4. `open_target_screen`
5. `prepare_inputs`
6. `fill_prompt_or_form`
7. `upload_refs`
8. `submit_generation`
9. `wait_for_result`
10. `collect_outputs`
11. `download_or_capture_artifacts`
12. `return_structured_result`

## Selector rules

Prefer:

- locators;
- roles;
- labels;
- stable text anchors;
- service-specific helper functions.

Avoid:

- raw `nth-child` chains;
- fixed sleeps as the main wait strategy;
- one giant page script;
- silent fallback to success.

## Debug artifacts

Every flow must record:

- step log;
- screenshot on failure;
- final screenshot;
- Playwright trace if tracing enabled;
- downloaded files list;
- profile state;
- failure class.

## Session/profile lifecycle

Implement explicit setup/status commands:

- `worker profile setup gemini`
- `worker profile setup freepik`
- `worker profile setup kling`
- `worker profile status`

States:

- `unknown`
- `needs_setup`
- `authenticated`
- `expired`
- `broken`

## Waiting policy

Do not rely on fixed sleeps for generation completion. Prefer:

- result card visible;
- download button enabled;
- loading indicator gone;
- network/DOM condition;
- timeout with failure class.

## Source inspiration

Adapted for this project from `lackeyjb/playwright-skill` and `willcoliveira/qualiow-playwright-skills`.
