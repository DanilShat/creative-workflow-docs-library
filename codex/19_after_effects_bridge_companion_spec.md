# After Effects Bridge Companion Spec

> CURRENT OVERRIDE: Server owns planning, orchestration, state and local LLM access. Designer-side worker/host bridges execute typed allowlisted actions only. Panels may expose local context and ask for approval, but they do not own authoritative workflow state and must not call an LLM directly for authoritative planning. DCC live execution is post-Gate-A, after the Gemini + Freepik browser E2E slice.

## Goal
Build a controlled After Effects integration that behaves like a side companion for repetitive scene-assembly actions.

## Recommended mode for V1
Conservative bridge.
Use a narrow action catalog and deterministic execution.
A script bridge is acceptable for V1 if a richer panel is not ready yet.

## UX model
The user asks for action from the main app or from a lightweight AE-side entry point.
The system shows the plan, then executes only allowlisted actions.

## V1 action catalog
- `after_effects.get_project_context`
- `after_effects.import_assets`
- `after_effects.create_comp_from_preset`
- `after_effects.place_asset_on_timeline`
- `after_effects.precompose_selection`
- `after_effects.add_to_render_queue`
- `after_effects.export_render_queue_manifest`

## Schemas
```python
class GetProjectContextArgs(BaseModel):
    pass

class ImportAssetsArgs(BaseModel):
    file_paths: list[str]
    destination_folder_name: str | None = None

class CreateCompFromPresetArgs(BaseModel):
    name: str
    width: int
    height: int
    duration: float
    fps: float

class PlaceAssetOnTimelineArgs(BaseModel):
    comp_name: str
    asset_name: str
    start_time: float = 0.0
    layer_order: int | None = None

class PrecomposeSelectionArgs(BaseModel):
    new_comp_name: str
    move_all_attributes: bool = True

class AddToRenderQueueArgs(BaseModel):
    comp_name: str
    render_settings_template: str | None = None
    output_module_template: str | None = None
```

## Project context payload
```json
{
  "project_open": true,
  "project_name": "campaign_scenes.aep",
  "active_item_name": "scene_03_main",
  "comp_names": ["scene_01", "scene_02", "scene_03_main"],
  "render_queue_count": 1
}
```

## Why narrow scope
AE is powerful but the automation surface is broad and error-prone.
V1 should automate only repetitive deterministic setup tasks.

## Suggested execution styles
### Option A
Main app plans actions -> AE bridge executes.

### Option B
AE helper receives exported plan file -> executes it -> writes result log.

## Non-goals
- full autonomous editing
- arbitrary effect graph manipulation
- free-form motion design by natural language alone
- generic script execution endpoint
