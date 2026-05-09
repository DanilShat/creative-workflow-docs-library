---
name: after-effects-bridge
description: Use when implementing After Effects bridge, CEP/panel/CLI communication, ExtendScript action execution, project querying, comp/layer operations, or render queue handoff.
---

# After Effects Bridge Skill

## Use when

Use this skill for:

- AE bridge implementation;
- project/composition context extraction;
- allowlisted ExtendScript actions;
- importing generated assets;
- creating comps;
- placing layers on timeline;
- render queue handoff.

## MVP position

After Effects integration is more conservative than Photoshop.

MVP goal: automate repetitive setup and handoff tasks, not become a fully autonomous motion designer.

## Allowed action examples

- `aftereffects.get_project_context`
- `aftereffects.import_assets`
- `aftereffects.create_comp_from_preset`
- `aftereffects.place_asset_on_timeline`
- `aftereffects.set_layer_duration`
- `aftereffects.precompose_selection`
- `aftereffects.add_to_render_queue`
- `aftereffects.export_project_summary`

## Safety rules

- wrap actions in undo groups when possible;
- no arbitrary generated ExtendScript in normal MVP mode;
- validate comp names, file paths and duration values;
- return structured result/error payloads;
- prefer small deterministic scripts over large generated scripts.

## Context policy

Query only what is needed:

- project summary;
- active comp;
- selected layers;
- needed layer properties;
- missing footage list.

Do not dump full project state into the agent unless diagnosing.

## Source inspiration

Adapted from `aedev-tools/adobe-agent-skills` and `yumehiko/ae-agent-skills`, but tightened for this MVP: allowlisted actions first, arbitrary generated code out of normal scope.
