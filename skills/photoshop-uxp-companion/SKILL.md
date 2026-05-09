---
name: photoshop-uxp-companion
description: Use when implementing Photoshop side panel, UXP plugin behavior, local bridge communication, document context reading, or allowlisted Photoshop host actions.
---

# Photoshop UXP Companion Skill

## Use when

Use this skill for:

- Photoshop side panel implementation;
- UXP plugin structure;
- local bridge calls;
- reading active document/layer context;
- executing allowlisted Photoshop actions;
- reporting action results to the worker/server.

## MVP architecture

Photoshop integration is a companion panel, not a free-form code executor.

Flow:

1. designer opens Photoshop document;
2. panel connects to local worker/bridge;
3. panel exposes context summary;
4. server sends typed host action through worker;
5. panel previews or confirms where needed;
6. action executes;
7. result/error returns to worker and server.

## Allowed action policy

MVP actions must be typed and allowlisted, for example:

- `photoshop.get_document_context`
- `photoshop.crop_canvas`
- `photoshop.resize_image`
- `photoshop.resize_canvas`
- `photoshop.export_active_document`
- `photoshop.export_selected_layer`
- `photoshop.place_asset`
- `photoshop.rename_layer`
- `photoshop.create_guides_for_format`

No arbitrary generated JS execution in MVP.

## Safety requirements

- validate all inputs;
- prefer preview/confirm for destructive actions;
- keep actions undoable where possible;
- never write outside approved workspace/export folders unless user chooses path;
- return structured errors.

## Bridge contract

A host action result must include:

- `success`;
- `action_name`;
- `document_id` or document name;
- output paths if exported;
- changed entities;
- warnings;
- error class/message if failed.

## Source inspiration

Adapted from official Adobe Photoshop UXP docs/samples, `adobe/skills`, and practical UXP tooling ideas from `bubblydoo/uxp-toolkit`.
