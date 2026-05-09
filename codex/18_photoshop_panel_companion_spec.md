# Photoshop Panel Companion Spec

> CURRENT OVERRIDE: Server owns planning, orchestration, state and local LLM access. Designer-side worker/host bridges execute typed allowlisted actions only. Panels may expose local context and ask for approval, but they do not own authoritative workflow state and must not call an LLM directly for authoritative planning. DCC live execution is post-Gate-A, after the Gemini + Freepik browser E2E slice.

## Goal
Build a Photoshop side-panel companion that communicates with the designer worker/Photoshop bridge and executes a narrow allowlisted set of actions inside Photoshop. Planning, local LLM access and authoritative workflow state remain server-owned.

## Official implementation surface
Target Adobe Photoshop UXP plugin architecture.
Do not use legacy pathways as the primary new-build choice.

## UX model
The panel is always visible as a side window inside Photoshop.

### Panel sections
1. Connection status
2. Active document context
3. Prompt / instruction input
4. Generated plan preview
5. Action approval buttons
6. Last execution log

## Responsibilities
- read active document context
- send context + user intent through the approved worker/server path
- receive typed action plan
- show plan in human-readable form
- execute approved actions
- report structured results back

## V1 action catalog
- `photoshop.get_active_document_context`
- `photoshop.crop_canvas`
- `photoshop.resize_image`
- `photoshop.duplicate_active_layer`
- `photoshop.rename_active_layer`
- `photoshop.export_active_document`
- `photoshop.save_copy_as`

## Per-action schemas
```python
class GetActiveDocumentContextArgs(BaseModel):
    pass

class CropCanvasArgs(BaseModel):
    width: int
    height: int
    anchor: Literal["center", "top", "bottom", "left", "right"] = "center"

class ResizeImageArgs(BaseModel):
    width: int
    height: int
    resample_mode: str = "automatic"

class RenameActiveLayerArgs(BaseModel):
    new_name: str

class ExportActiveDocumentArgs(BaseModel):
    output_dir: str
    format: Literal["jpg", "png"]
    quality: int | None = None

class SaveCopyAsArgs(BaseModel):
    output_path: str
    format: Literal["psd", "jpg", "png"]
```

## Context payload
The plugin should return a context payload such as:
```json
{
  "document_open": true,
  "title": "hero_v3.psd",
  "width": 1080,
  "height": 1350,
  "resolution": 72,
  "path": "C:/.../hero_v3.psd",
  "active_layer_name": "Hero",
  "layer_count": 14
}
```

## Execution policy
- no arbitrary code textarea for V1
- no hidden auto-run
- user must see the plan before execution
- destructive file actions require confirmation

## Suggested implementation notes
- use UXP panel UI
- keep a small local HTTP client in the plugin
- maintain a per-session execution log in panel state
- persist only structured results back through the worker/server path

## Non-goals
- complex masking flows
- smart object deep automation
- free-form retouch automation
- direct LLM execution inside the plugin
