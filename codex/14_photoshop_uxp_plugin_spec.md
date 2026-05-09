# Photoshop UXP Plugin Spec

## Objective
Build a lightweight Photoshop companion plugin/panel that can receive approved host actions from the designer worker/bridge and execute them inside Photoshop. Planning, local LLM access and authoritative workflow state remain server-owned.

## Why Photoshop first
Photoshop is the strongest target for V1 because its extensibility surface is modern and explicit.

## Integration model
- UXP panel/plugin
- local HTTP bridge to the designer worker or Photoshop bridge
- action catalog inside the plugin
- preview/approve UI in panel

## Responsibilities of the Photoshop plugin
- discover active document context
- expose current document metadata
- execute allowlisted actions
- save/export outputs to workspace folders
- return execution status

## Initial action catalog
- `photoshop.get_active_document_context`
- `photoshop.crop_canvas`
- `photoshop.resize_image`
- `photoshop.duplicate_active_layer`
- `photoshop.rename_active_layer`
- `photoshop.export_active_document`
- `photoshop.save_copy_as`

## Example action schema
```python
class CropCanvasArgs(BaseModel):
    width: int
    height: int
    anchor: Literal["center", "top", "bottom", "left", "right"] = "center"
```

## Plugin UI
Minimal panel with:
- connection status to the worker/Photoshop bridge
- active document summary
- last planned action
- approve / run / cancel buttons
- execution log area

## Data flow
```text
Photoshop document -> UXP plugin reads context -> sends context through worker/server path
Server plans typed action -> worker/bridge provides approved action -> plugin executes -> result returns to server history
```

## Non-goals for V1
- arbitrary prompt-to-code execution inside Photoshop
- complex layer masking pipelines
- smart object deep editing automation
- replacement for native Photoshop workflows
