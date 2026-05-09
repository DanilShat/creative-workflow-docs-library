# CapCut Constraints and Fallbacks

## Positioning
Do not assume CapCut has a stable public desktop plugin or scripting SDK suitable for this project.

## Current design stance
CapCut is not a first-class host integration target in V1.

## Recommended usage modes
### Option A — manual handoff
Export assets/manifests so the designer continues in CapCut manually.

### Option B — browser automation
Automate official web workflows where that gives value and is supportable.

### Option C — desktop UI automation
Only if absolutely necessary, and only after static/video browser workflows are already stable.

## Why this conservative stance exists
Without a clear public host extensibility model, a plugin-first architecture for CapCut would be high-risk and expensive to maintain.

## V1 decision
No CapCut plugin work in V1.
