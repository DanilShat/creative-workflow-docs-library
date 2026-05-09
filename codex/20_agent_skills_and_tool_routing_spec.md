# Agent Skills and Tool Routing for DCC Hosts

## Objective
Define how the agent reasons about Photoshop and After Effects actions without turning into an arbitrary code generator.

## Rule
The agent plans with tools and skills, not with free-form host code.

## Tool groups
### Photoshop tools
- `tool.photoshop.get_active_document_context`
- `tool.photoshop.crop_canvas`
- `tool.photoshop.resize_image`
- `tool.photoshop.duplicate_active_layer`
- `tool.photoshop.rename_active_layer`
- `tool.photoshop.export_active_document`
- `tool.photoshop.save_copy_as`

### After Effects tools
- `tool.after_effects.get_project_context`
- `tool.after_effects.import_assets`
- `tool.after_effects.create_comp_from_preset`
- `tool.after_effects.place_asset_on_timeline`
- `tool.after_effects.precompose_selection`
- `tool.after_effects.add_to_render_queue`
- `tool.after_effects.export_render_queue_manifest`

## Agent skills
### `skill.identify_host`
Decides whether the request belongs to Photoshop or After Effects.

### `skill.fetch_host_context`
Calls the relevant context tool before planning actions.

### `skill.plan_allowlisted_actions`
Maps user intent to one or more known host actions.

### `skill.validate_host_action_inputs`
Checks required args and catches impossible plans early.

### `skill.preview_host_plan`
Produces a concise human-readable summary before execution.

### `skill.execute_confirmed_actions`
Executes actions only after user confirmation.

### `skill.handle_host_failure`
Transforms bridge failures into repairable next steps.

## Routing examples
### Example 1
User: "crop this image to 4:5 and export a jpg copy"

Route:
1. `tool.photoshop.get_active_document_context`
2. `tool.photoshop.crop_canvas`
3. `tool.photoshop.export_active_document`

### Example 2
User: "import all generated clips into AE and create a vertical comp"

Route:
1. `tool.after_effects.get_project_context`
2. `tool.after_effects.import_assets`
3. `tool.after_effects.create_comp_from_preset`

## Forbidden default behavior
- generating raw host scripts and executing them directly
- executing unknown host action names
- skipping confirmation on destructive actions
- mutating files outside the configured workspace without confirmation

## Suggested planner output
```json
{
  "host": "photoshop",
  "summary": "Crop active document to 1080x1350 and export JPG copy",
  "actions": [
    {"action_name": "get_active_document_context", "args": {}},
    {"action_name": "crop_canvas", "args": {"width": 1080, "height": 1350, "anchor": "center"}},
    {"action_name": "export_active_document", "args": {"output_dir": "C:/workspace/exports", "format": "jpg", "quality": 10}}
  ]
}
```
