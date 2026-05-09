# Browser Automation Specification

## Core requirement
Vendor integrations work through browser automation because the agency workflow uses web subscriptions, not API keys.

## Technology
- Playwright for Python
- persistent browser profiles
- headed mode by default
- optional headless mode only for advanced debug scenarios

## Profile lifecycle
Profile states:
- `needs_setup`: no usable session exists
- `authenticated`: validation check passed
- `expired`: site redirects to login or sign-in detected
- `broken`: profile cannot launch or storage is corrupted
- `unknown`: not checked yet

Required commands:
```bash
worker profile setup gemini
worker profile setup freepik
worker profile status
worker profile status gemini
worker profiles list
```

Setup behavior:
1. Launch headed browser with persistent profile for service.
2. Open target site.
3. User logs in manually.
4. Worker runs validation check.
5. Store profile status locally and report in heartbeat.

Validation checks:
- Gemini: logged-in chat input available and no sign-in gate.
- Freepik: app is accessible and generation UI or user/account area is visible.

## Core components
- `BrowserSessionManager`
- `ProfileManager`
- `BaseProviderFlow`
- `GeminiPromptFlow`
- `FreepikImageFlow`
- `DebugArtifactManager`
- `DownloadManager`

## Flow state machine
- init
- open_profile
- validate_auth
- open_target_screen
- prepare_inputs
- upload_refs
- fill_prompt
- submit
- wait_for_result
- collect_outputs
- download_outputs
- upload_debug_artifacts
- return_result

## Structured flow result
See `codex/27_job_schema_and_state_machine.md`.

## Debug artifacts
Every live browser job should capture:
- final screenshot
- screenshot on failure
- Playwright trace if enabled
- HTML snapshot on failure when safe
- text extraction output for Gemini response
- step log

Debug assets use retention class `debug_ttl_7d`.

## Manual takeover mode
If automation is blocked by login, captcha, changed UI or upload glitch:
- job fails with classified failure if it cannot safely resume;
- or pauses locally only if manual intervention is explicitly supported;
- worker must not hold a server lease indefinitely;
- if human action is needed, prefer failure class `needs_reauth` or `selector_broken` and return control to server.

## First required flows
### `gemini_build_prompt_from_brief_and_refs`
Input:
- brief text
- reference asset ids
- prompt-builder instruction

Output:
- `prompt_text`
- optional `negative_prompt`
- raw response/debug artifact

### `freepik_generate_image_from_prompt`
Input:
- prompt text
- reference asset ids
- settings

Output:
- generated downloaded asset ids
- debug asset ids
- visible provider/model metadata if available

## Selector rules
Use Playwright locators, roles, labels and text anchors. Avoid brittle `nth-child` selectors unless there is no alternative, and document brittle selectors in code comments.
