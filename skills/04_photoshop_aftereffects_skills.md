# Photoshop and After Effects Skills

These are allowlisted host skills, not arbitrary code execution.

## Photoshop skills
- `photoshop.get_active_document_context`
- `photoshop.crop_canvas`
- `photoshop.resize_image`
- `photoshop.export_active_document`
- `photoshop.place_asset`
- `photoshop.list_layers_basic`

## After Effects skills
- `aftereffects.get_project_context`
- `aftereffects.import_assets`
- `aftereffects.create_comp_from_preset`
- `aftereffects.place_asset_on_timeline`
- `aftereffects.precompose_selection`
- `aftereffects.add_to_render_queue`

## Safety principles
- only allowlisted actions
- typed arguments
- explicit validation
- preview/confirm where needed
- never let the LLM execute unrestricted host code by default
